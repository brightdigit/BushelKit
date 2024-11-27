#WORKSPACE_PATH="PSPDFKit.xcworkspace"
SCHEME="BushelKit-Package"
DERIVED_DATA_DIR="$HOME/Documents/docc-derived-data"
SYMBOL_GRAPHS_DIR="$HOME/Documents/combined-symbol-graphs"
OUTPUT_DIR="./public"

xcodebuild docbuild -destination 'generic/platform=macOS' \
	-scheme "${SCHEME}" \
	-derivedDataPath "${DERIVED_DATA_DIR}"

mkdir -p "${SYMBOL_GRAPHS_DIR}"
find "$HOME/Documents/docc-derived-data/Build/Intermediates.noindex" -path "*.build/Debug/*.build/symbol-graph" -exec cp -r {} "${SYMBOL_GRAPHS_DIR}" \;

xcodebuild docbuild -scheme BushelKit-destination generic/platform=macOS -sdk macosx -derivedDataPath "${DERIVED_DATA_DIR}" \
  # --additional-symbol-graph-dir "${SYMBOL_GRAPHS_DIR}" \
  --fallback-display-name BushelKit --fallback-bundle-identifier com.brightdigit.BushelKit --fallback-bundle-version 2 

archive_path=$(find "$DERIVED_DATA_DIR" -path "*/Build/Products/*/BushelKit.doccarchive" -type d | head -n 1)
# xcrun docc preview \
#   --fallback-display-name BushelKit --fallback-bundle-identifier com.brightdigit.BushelKit --fallback-bundle-version 2 \
#   --output-dir ~/Documents/BushelKit.doccarchive \
#   --additional-symbol-graph-dir "${SYMBOL_GRAPHS_DIR}"
  
xcrun docc  process-archive \
  transform-for-static-hosting "$archive_path" \
  --output-path "$OUTPUT_DIR" \
  --hosting-base-path "/Swift"