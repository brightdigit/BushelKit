#!/bin/sh

if [ -z "$SRCROOT" ]; then
	SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
	PACKAGE_DIR="${SCRIPT_DIR}/../Packages/BushelKit"
else
	PACKAGE_DIR="${SRCROOT}/Packages/BushelKit" 	
fi

if [ "$STRICT_MODE" == "true" ] || [ "$STRICT_MODE" = "YES" ]; then
	SWIFTFORMAT_OPTIONS=""
	SWIFTLINT_OPTIONS="--strict"
	STRINGSLINT_OPTIONS="--config .strict.stringslint.yml"
else 
	SWIFTFORMAT_OPTIONS=""
	SWIFTLINT_OPTIONS=""
	STRINGSLINT_OPTIONS="--config .stringslint.yml"
fi

pushd $PACKAGE_DIR
swift package resolve
swift build -c release

if [ -z "$CI" ]; then
	swift run -c release swiftformat .
	swift run -c release swiftlint --autocorrect
else 
	set -e
fi

swift run -c release stringslint lint $STRINGSLINT_OPTIONS
swift run -c release swiftformat --lint $SWIFTFORMAT_OPTIONS .
swift run -c release swiftlint lint $SWIFTLINT_OPTIONS
popd
