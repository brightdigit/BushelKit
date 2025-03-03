#!/bin/sh

set -e  # Exit on any error

ERRORS=0

# Detect OS and set paths accordingly
if [ "$(uname)" = "Darwin" ]; then
    DEFAULT_MINT_PATH="/opt/homebrew/bin/mint"
elif [ "$(uname)" = "Linux" ] && [ -n "$GITHUB_ACTIONS" ]; then
    DEFAULT_MINT_PATH="$GITHUB_WORKSPACE/Mint/.mint/bin/mint"
elif [ "$(uname)" = "Linux" ]; then
    DEFAULT_MINT_PATH="/usr/local/bin/mint"
else
    echo "Unsupported operating system"
    exit 1
fi

run_command() {
		if [ "$LINT_MODE" == "STRICT" ]; then
				"$@" || ERRORS=$((ERRORS + 1))
		else
				"$@"
		fi
}

# More portable way to get script directory
if [ -z "$SRCROOT" ]; then
    SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
    PACKAGE_DIR="${SCRIPT_DIR}/.."
	PERIPHERY_OPTIONS=""
else
    PACKAGE_DIR="${SRCROOT}"     
	PERIPHERY_OPTIONS=""
fi

# Use environment MINT_CMD if set, otherwise use default path
MINT_CMD=${MINT_CMD:-$DEFAULT_MINT_PATH}

export MINT_PATH="$PWD/.mint"
MINT_ARGS="-n -m ../../Mintfile --silent"
MINT_RUN="$MINT_CMD run $MINT_ARGS"


if [ "$LINT_MODE" == "NONE" ]; then
	exit
elif [ "$LINT_MODE" == "STRICT" ]; then
	SWIFTFORMAT_OPTIONS="--strict --configuration .swift-format"
	SWIFTLINT_OPTIONS="--strict"
	STRINGSLINT_OPTIONS="--config .strict.stringslint.yml"
else 
	SWIFTFORMAT_OPTIONS="--configuration .swift-format"
	SWIFTLINT_OPTIONS=""
	STRINGSLINT_OPTIONS="--config .stringslint.yml"
fi

run_command $MINT_CMD bootstrap -m Mintfile

echo "LintMode: $LINT_MODE"

if [ "$LINT_MODE" == "INSTALL" ]; then
	exit
fi

if [ -z "$CI" ]; then
	run_command $MINT_RUN swiftlint --fix
	pushd $PACKAGE_DIR
	run_command $MINT_RUN swift-format format $SWIFTFORMAT_OPTIONS  --recursive --parallel --in-place Sources Tests
	popd
else 
	set -e
fi

$PACKAGE_DIR/Scripts/header.sh -d  $PACKAGE_DIR/Sources -c "Leo Dion" -o "BrightDigit" -p "BushelKit"

run_command $MINT_RUN stringslint lint $STRINGSLINT_OPTIONS
run_command $MINT_RUN swiftlint lint $SWIFTLINT_OPTIONS

pushd $PACKAGE_DIR
run_command $MINT_RUN swift-format lint --recursive --parallel $SWIFTFORMAT_OPTIONS Sources Tests
#$MINT_RUN periphery scan $PERIPHERY_OPTIONS --disable-update-check
popd
