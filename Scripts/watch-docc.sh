#!/bin/bash

# Configuration - Add your schemes here
SCHEMES=(
    "bushel"
    "BushelDocs"
    "BushelFactory"
    "BushelFoundation"
    "BushelFoundationWax"
    "BushelGuestProfile"
    "BushelHub"
    "BushelHubIPSW"
    "BushelHubMacOS"
    "BushelLibrary"
    "BushelLogging"
    "BushelMacOSCore"
    "BushelMachine"
    "BushelTestUtilities"
    "BushelUT"
    "BushelUtilities"
    "BushelVirtualBuddy"
)

# Help message
show_usage() {
    echo "Usage: $0"
    echo "Watches the following schemes for changes:"
    for scheme in "${SCHEMES[@]}"; do
        echo "  - Sources/$scheme"
    done
    exit 1
}

# Configuration
TEMP_DIR=$(mktemp -d)
OUTPUT_DIR="./public"
PORT=8000

# Global variables for process management
SERVER_PID=""
FSWATCH_PID=""

# Cleanup function for all processes and temporary directory
cleanup() {
    echo -e "\nCleaning up..."
    
    # Kill the Python server
    if [ ! -z "$SERVER_PID" ]; then
        echo "Stopping web server (PID: $SERVER_PID)..."
        kill -9 "$SERVER_PID" 2>/dev/null
        wait "$SERVER_PID" 2>/dev/null
    fi
    
    # Kill fswatch
    if [ ! -z "$FSWATCH_PID" ]; then
        echo "Stopping file watcher (PID: $FSWATCH_PID)..."
        kill -9 "$FSWATCH_PID" 2>/dev/null
        wait "$FSWATCH_PID" 2>/dev/null
    fi
    
    # Kill any remaining Python servers on our port
    local remaining_servers=$(lsof -ti:$PORT)
    if [ ! -z "$remaining_servers" ]; then
        echo "Cleaning up remaining processes on port $PORT..."
        kill -9 $remaining_servers 2>/dev/null
    fi
    
    echo "Removing temporary directory..."
    rm -rf "$TEMP_DIR"
    
    echo "Cleanup complete"
    exit 0
}

# Register cleanup function for multiple signals
trap cleanup EXIT INT TERM

# Validate watch directories and create array of directories to watch
WATCH_DIRS=()
for scheme in "${SCHEMES[@]}"; do
    dir="Sources/$scheme"
    if [ ! -d "$dir" ]; then
        echo "Error: Directory '$dir' does not exist"
        exit 1
    fi
    WATCH_DIRS+=("$dir")
done

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check for required tools
if ! command -v fswatch >/dev/null 2>&1; then
    echo "Error: This script requires fswatch on macOS."
    echo "Install it using: brew install fswatch"
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    echo "Error: This script requires python3 for the web server."
    exit 1
fi

# Function to find the .doccarchive file for a specific scheme
find_doccarchive() {
    local scheme="$1"
    # First try to find in a scheme-specific directory
    local archive_path=$(find "$TEMP_DIR" -path "*/Build/Products/*/$scheme.doccarchive" -type d | head -n 1)
    
    # If not found, try finding by scheme name anywhere
    if [ -z "$archive_path" ]; then
        archive_path=$(find "$TEMP_DIR" -name "$scheme.doccarchive" -type d | head -n 1)
    fi
    
    if [ -z "$archive_path" ]; then
        echo "Error: Could not find .doccarchive file for scheme $scheme"
        return 1
    fi
    echo "$archive_path"
}

# Function to start the web server
start_server() {
    # Check if something is already running on the port
    if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null ; then
        echo "Port $PORT is already in use. Attempting to clean up..."
        kill -9 $(lsof -ti:$PORT) 2>/dev/null
        sleep 1
    fi
    
    echo "Starting web server on http://localhost:$PORT ..."
    cd "$OUTPUT_DIR" && python3 -m http.server $PORT &
    SERVER_PID=$!
    cd - > /dev/null
    
    # Wait a moment to ensure server starts
    sleep 1
    
    # Verify server started successfully
    if ! lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null ; then
        echo "Failed to start web server"
        exit 1
    fi
    
    echo "Documentation is now available at: http://localhost:$PORT"
}

# Function to determine which scheme a file belongs to
get_scheme_for_file() {
    local file_path="$1"
    for scheme in "${SCHEMES[@]}"; do
        if [[ "$file_path" == *"Sources/$scheme"* ]]; then
            echo "$scheme"
            return 0
        fi
    done
    return 1
}

# Function to rebuild documentation for a specific scheme
rebuild_docs() {
    local file="$1"
    local scheme="$2"
    
    echo "Changes detected in: $file"
    echo "Rebuilding documentation for scheme: $scheme"
    
    # Clean temporary directory contents for this scheme
    rm -rf "$TEMP_DIR/Build/Products"/*/"$scheme.doccarchive"
    
    # Build documentation for the specific scheme
    local build_cmd="xcodebuild docbuild -scheme $scheme -destination generic/platform=macOS -sdk macosx -derivedDataPath $TEMP_DIR"
    eval "$build_cmd"
    if [ $? -ne 0 ]; then
        echo "Error building documentation for $scheme"
        return 1
    fi
    
    # Find the .doccarchive file for this scheme
    local archive_path=$(find_doccarchive "$scheme")
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    echo "Found documentation archive at: $archive_path"
    
    # Process the archive for static hosting
    echo "Processing documentation for static hosting..."
    $(xcrun --find docc) process-archive \
        transform-for-static-hosting "$archive_path" \
        --output-path "$OUTPUT_DIR/$scheme" \
        --hosting-base-path "/$scheme"
        
    if [ $? -eq 0 ]; then
        echo "Documentation for $scheme rebuilt successfully at $(date '+%H:%M:%S')"
        echo "Documentation available at: http://localhost:$PORT/$scheme"
    else
        echo "Error processing documentation archive for $scheme"
    fi
}

# Initial build for all schemes
echo "Performing initial documentation build for all schemes..."
for scheme in "${SCHEMES[@]}"; do
    rebuild_docs "initial build" "$scheme"
done

# Start the web server after initial build
start_server

# Watch for changes
echo "Watching for changes in Swift and Markdown files..."
echo "Watching directories:"
printf '%s\n' "${WATCH_DIRS[@]}"

fswatch -r "${WATCH_DIRS[@]}" | while read -r file; do
    if [[ "$file" =~ \.(swift|md)$ ]] || [[ "$file" =~ \.docc/ ]]; then
        scheme=$(get_scheme_for_file "$file")
        if [ ! -z "$scheme" ]; then
            rebuild_docs "$file" "$scheme"
        fi
    fi
done &
FSWATCH_PID=$!

# Wait for fswatch to exit (which should only happen if there's an error)
wait $FSWATCH_PID