#!/bin/sh

set -o pipefail

ERRORS=0

run_command() {
		if [ "$LINT_MODE" == "STRICT" ]; then
				"$@" || ERRORS=$((ERRORS + 1))
		else
				"$@"
		fi
}

if [ "$ACTION" == "install" ]; then 
	if [ -n "$SRCROOT" ]; then
		exit
	fi
fi

export MINT_PATH="$PWD/.mint"
MINT_ARGS="-n -m Mintfile --silent"
MINT_RUN="/opt/homebrew/bin/mint run $MINT_ARGS"

if [ -z "$SRCROOT" ]; then
	SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
	PACKAGE_DIR="${SCRIPT_DIR}/.."
	
else
	PACKAGE_DIR="${SRCROOT}" 
fi


if [ "$LINT_MODE" == "NONE" ]; then
		exit
elif [ "$LINT_MODE" == "STRICT" ]; then
		SWIFTFORMAT_OPTIONS="--strict"
		SWIFTLINT_OPTIONS="--strict"
		STRINGSLINT_OPTIONS="--config .strict.stringslint.yml"
else
		SWIFTFORMAT_OPTIONS=""
		SWIFTLINT_OPTIONS=""
		STRINGSLINT_OPTIONS="--config .stringslint.yml"
fi
/opt/homebrew/bin/mint bootstrap

echo "LINT Mode is $LINT_MODE"

if [ "$LINT_MODE" == "INSTALL" ]; then
	exit
fi

if [ -z "$CI" ]; then
	run_command $MINT_RUN swiftlint --fix
	run_command $MINT_RUN swift-format format --recursive --parallel --in-place $PACKAGE_DIR/Sources
else 
	set -e
fi

$PACKAGE_DIR/scripts/header.sh -d  $PACKAGE_DIR/Sources -c "Leo Dion" -o "BrightDigit" -p "Sublimation"
run_command $MINT_RUN stringslint lint $STRINGSLINT_OPTIONS
run_command $MINT_RUN swiftlint lint $SWIFTLINT_OPTIONS
run_command $MINT_RUN swift-format lint --recursive --parallel $SWIFTFORMAT_OPTIONS $PACKAGE_DIR/Sources

pushd $PACKAGE_DIR
run_command $MINT_RUN periphery scan $PERIPHERY_OPTIONS --disable-update-check
popd

if [ "$LINT_MODE" == "STRICT" ] && [ $ERRORS -gt 0 ]; then
		echo "Linting failed with $ERRORS error(s)"
		exit 1
fi