//
//  Index.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import PackageDescription

// swift-docc-plugin ships its shared plugin sources via symbolic links that do
// not survive checkout on Windows, so building its plugins fails there (cannot
// find 'Lock'/'SnippetExtractor' in scope). The manifest is compiled per host,
// so gate the dependency off Windows via the closure below; docc generation is
// not run on Windows anyway and no target depends on the plugin, so omitting it
// there is safe.
let package = {
  #if os(Windows)
    Package(
      name: "BushelKit",
      entries: PackageEntries,
      testTargets: PackageTestTargets,
      swiftSettings: PackageSwiftSettings
    )
  #else
    Package(
      name: "BushelKit",
      entries: PackageEntries,
      dependencies: {
        DocC()
      },
      testTargets: PackageTestTargets,
      swiftSettings: PackageSwiftSettings
    )
  #endif
}()
.supportedPlatforms {
  MinimumPlatforms()
}
.defaultLocalization(.english)

@ProductsBuilder
private func PackageEntries() -> [any Product] {
  BushelCommand()
  BushelFoundation()
  BushelDocs()
  BushelUtilities()
  BushelFoundationWax()
  BushelFactory()
  BushelGuestProfile()
  BushelHarvestCore()
  BushelHub()
  BushelHubIPSW()
  BushelHubMacOS()
  BushelLibrary()
  BushelLogging()
  BushelMachine()
  BushelMacOSCore()
  BushelUT()
  BushelVirtualBuddy()
  BushelTestUtilities()
}

@TestTargetBuilder
private func PackageTestTargets() -> any TestTargets {
  BushelFoundationTests()
  BushelLibraryTests()
  BushelMachineTests()
  BushelFactoryTests()
  BushelUtlitiesTests()
  BushelHarvestCoreTests()
}

@SwiftSettingsBuilder
private func PackageSwiftSettings() -> [SwiftSetting] {
  AccessLevelOnImport()
  NestedProtocols()
  NoncopyableGenerics()
  VariadicGenerics()
  InternalImportsByDefault()
}
