#!/bin/sh

if [ "$ACTION" == "install" ]; then 
	if [ -n "$SRCROOT" ]; then
		exit
	fi
fi

export MINT_PATH="$PWD/.mint"
MINT_ARGS="-n -m ../../Mintfile --silent"
MINT_RUN="/opt/homebrew/bin/mint run $MINT_ARGS"

/opt/homebrew/bin/mint bootstrap

function lint_swift_package() {
	pushd $1
	
	if [ -z "$CI" ]; then
		$MINT_RUN swiftformat .
		$MINT_RUN swiftlint autocorrect
	else 
		set -e
	fi
	
	#$MINT_RUN periphery scan 
	
	if test -f .stringslint.yml; then
		$MINT_RUN stringslint lint $STRINGSLINT_OPTIONS
	fi
	$MINT_RUN swiftformat --lint $SWIFTFORMAT_OPTIONS .
	$MINT_RUN swiftlint lint $SWIFTLINT_OPTIONS
	
	popd
}

if [ "$LINT_MODE" == "NONE" ]; then
	exit
elif [ "$LINT_MODE" == "STRICT" ]; then
	SWIFTFORMAT_OPTIONS=""
	SWIFTLINT_OPTIONS="--strict"
	STRINGSLINT_OPTIONS="--config .strict.stringslint.yml"
else 
	SWIFTFORMAT_OPTIONS=""
	SWIFTLINT_OPTIONS=""
	STRINGSLINT_OPTIONS="--config .stringslint.yml"
fi

if [ -z "$SRCROOT" ]; then
	SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
	PACKAGE_PARENT_DIR="${SCRIPT_DIR}/../Packages"
else
	PACKAGE_PARENT_DIR="${SRCROOT}/Packages" 	
fi

pushd $PACKAGE_PARENT_DIR

for packageDirectory in $PACKAGE_PARENT_DIR/*; do 
    DIR_NAME=`basename $packageDirectory`
	if [ "$DIR_NAME" == "PackageDSL" ]; then
	  continue
	fi
	lint_swift_package "$packageDirectory" &
done

wait

