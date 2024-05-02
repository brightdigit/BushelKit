#!/bin/sh

echo "⚙️  Generating package..."

if [ -z "$SRCROOT" ]; then
  SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  PACKAGE_DIR="${SCRIPT_DIR}/../Packages/BushelKit"
else
  PACKAGE_DIR="${SRCROOT}/Packages/BushelKit" 	
fi

cd $PACKAGE_DIR
echo "// swift-tools-version: 5.10" > Package.swift
cat Package/Support/*.swift >> Package.swift
cat Package/Sources/**/*.swift >> Package.swift
cat Package/Sources/*.swift >> Package.swift