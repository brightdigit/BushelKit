#!/usr/bin/env bash
set -euo pipefail

# Configuration
SCHEME="BushelKit-Package"
DERIVED_DATA_DIR="$HOME/Documents/docc-derived-data"
SYMBOL_GRAPHS_DIR="$HOME/Documents/combined-symbol-graphs"
OUTPUT_DIR="./public"
PLATFORM="generic/platform=macOS"

mkdir -p "${DERIVED_DATA_DIR}" "${SYMBOL_GRAPHS_DIR}" "${OUTPUT_DIR}"

echo "Building documentation..."
if ! xcodebuild docbuild -destination "${PLATFORM}" \
    -scheme "${SCHEME}" \
    -derivedDataPath "${DERIVED_DATA_DIR}"; then
    echo "Error: Initial documentation build failed"
    exit 1
fi

echo "Copying symbol graphs..."
if ! find "${DERIVED_DATA_DIR}/Build/Intermediates.noindex" \
    -path "*.build/Debug/*.build/symbol-graph" \
    -exec cp -r {} "${SYMBOL_GRAPHS_DIR}" \;; then
    echo "Error: Failed to copy symbol graphs"
    exit 1
fi

echo "Running final documentation build..."
if ! xcodebuild docbuild -scheme "${SCHEME}" \
    -destination "${PLATFORM}" \
    -sdk macosx \
    -derivedDataPath "${DERIVED_DATA_DIR}"; then
    echo "Error: Final documentation build failed"
    exit 1
fi

echo "Processing all archives..."
find "${DERIVED_DATA_DIR}" -path "*/Build/Products/*/*.doccarchive" -type d | while read -r archive_path; do
    echo "Processing archive: ${archive_path}"
    output_subdir="${OUTPUT_DIR}/Swift/$(basename "${archive_path}" .doccarchive)"
    mkdir -p "${output_subdir}"
    
    echo  "/Swift/$(basename "${archive_path}" .doccarchive)"
    if ! xcrun docc process-archive \
        transform-for-static-hosting "${archive_path}" \
        --output-path "${output_subdir}" \
        --hosting-base-path "/Swift/$(basename "${archive_path}" .doccarchive)"; then
        echo "Error: Failed to process archive ${archive_path}"
        exit 1
    fi
done

echo "Documentation build completed successfully"