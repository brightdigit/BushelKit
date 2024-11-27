#WORKSPACE_PATH="PSPDFKit.xcworkspace"
SCHEME="BushelKit-Package"
DERIVED_DATA_DIR="~/Documents/docc-derived-data"
SYMBOL_GRAPHS_DIR="~/Documents/combined-symbol-graphs"

xcodebuild docbuild -destination 'generic/platform=macOS' \
	-scheme "${SCHEME}" \
	-derivedDataPath "${DERIVED_DATA_DIR}"

mkdir -p "${SYMBOL_GRAPHS_DIR}"
find "$HOME/Documents/docc-derived-data/Build/Intermediates.noindex" -path "*.build/Debug/*.build/symbol-graph" -exec cp -r {} "${SYMBOL_GRAPHS_DIR}" \;

xcrun docc preview \
  --fallback-display-name BushelKit --fallback-bundle-identifier com.brightdigit.BushelKit --fallback-bundle-version 2 \
  --output-dir ~/Documents/BushelKit.doccarchive \
  --additional-symbol-graph-dir "${SYMBOL_GRAPHS_DIR}"