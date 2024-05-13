#!/bin/sh

swift_tools_version="5.10"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "⚙️  Generating package..."

if [ -z "$SRCROOT" ]; then
  PACKAGE_DIR="${SCRIPT_DIR}/../Packages"
else
  PACKAGE_DIR="${SRCROOT}/Packages" 	
fi

# Define directory names
directories=(
    "BushelKit"
    "BushelApp"
    # Add more directories as needed
)

cd $PACKAGE_DIR
# Loop through each directory
for directory in "${directories[@]}"; do
    # Change to the parent directory
    # cd "$parent_directory" || { echo "Failed to change directory to $parent_directory"; exit 1; }

    # Run your command here
    # For example, let's say you want to list the contents of each directory
    ${SCRIPT_DIR}/package.sh "$directory" "$swift_tools_version"
done