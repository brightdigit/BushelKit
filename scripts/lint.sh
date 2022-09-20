#!/bin/sh

if [ -z "$SRCROOT" ]; then
	SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
	PACKAGE_DIR="${SCRIPT_DIR}/../Packages/BushelKit"
else
	PACKAGE_DIR="${SRCROOT}/Packages/BushelKit" 	
fi

echo $STRICT_MODE

if [ "$STRICT_MODE" == "true" ]; then
	set -e
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

if [ -z "$CI" ]; then
	swift run swiftformat .
	swift run swiftlint --autocorrect
else 
	set -e
fi

swift run stringslint lint $STRINGSLINT_OPTIONS
swift run swiftformat --lint $SWIFTFORMAT_OPTIONS .
swift run swiftlint lint $SWIFTLINT_OPTIONS
popd
