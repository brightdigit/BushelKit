#!/bin/sh

if [ -z "$SRCROOT" ]; then
	SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
	PACKAGE_DIR="${SCRIPT_DIR}/../Packages/BushelKit"
else
	PACKAGE_DIR="${SRCROOT}/Packages/BushelKit" 	
fi

pushd $PACKAGE_DIR
swift package resolve

swift run swiftformat .
swift run swiftlint --autocorrect

swift run stringslint lint --path Sources
swift run swiftformat --lint .
swift run swiftlint lint
popd