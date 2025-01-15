#!/bin/bash

# Use pwd directly since we just need the script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGE_DIR="${SCRIPT_DIR}/.."
swift_tools_version="6.0"

input_file=.package.source
output_file=Package.swift

cd "$PACKAGE_DIR" || exit 1

echo "// swift-tools-version: $swift_tools_version" > "$input_file"

# Add error checking for directories
if [ -d "Package/Support" ]; then
    find Package/Support -name '*.swift' -type f -exec cat {} + >> "$input_file" 2>/dev/null
fi

if [ -d "Package/Sources" ]; then
    find Package/Sources -mindepth 2 -type f -name '*.swift' -not -path '*/\.*' -exec cat {} + >> "$input_file" 2>/dev/null
    
    # For direct Swift files in Sources
    if ls Package/Sources/*.swift 1>/dev/null 2>&1; then
        cat Package/Sources/*.swift >> "$input_file"
    fi
fi

# Collect unique import statements
imports=$(awk '/^import / {imports[$0]=1} END {for (i in imports) print i}' "$input_file")

# Remove empty lines, lines containing only comments, and import statements
awk '!/^[[:space:]]*(\/\/.*)?$|^import /' "$input_file" > "$output_file.tmp"

# Remove leading and trailing whitespace from each line
# Modified sed command for Linux compatibility
sed -i 's/^[[:space:]]*//;s/[[:space:]]*$//' "$output_file.tmp"

# Append collected import statements at the beginning of the file
echo "// swift-tools-version: $swift_tools_version" > "$output_file"
echo "$imports" >> "$output_file"
cat "$output_file.tmp" >> "$output_file"

# Clean up temporary file
rm "$output_file.tmp"