//
// Index.swift
// Copyright (c) 2024 BrightDigit.
//

import PackageDescription

let package = Package(
  entries: {
    BushelCommand()
    BushelCore()
    BushelCoreWax()
    BushelFactory()
    BushelGuestProfile()
    BushelHub()
    BushelHubIPSW()
    BushelHubMacOS()
    BushelLibrary()
    BushelLogging()
    BushelMachine()
    BushelMacOSCore()
    BushelProgressUI()
    BushelUT()
    BushelTestUtilities()
  },
  testTargets: {
    BushelCoreTests()
    BushelLibraryTests()
    BushelMachineTests()
    BushelFactoryTests()
  },
  swiftSettings: {
    Group("Experimental") {
      AccessLevelOnImport()
      BitwiseCopyable()
      GlobalActorIsolatedTypesUsability()
      IsolatedAny()
      MoveOnlyPartialConsumption()
      NestedProtocols()
      NoncopyableGenerics()
      RegionBasedIsolation()
      TransferringArgsAndResults()
      VariadicGenerics()
    }
    Group("Upcoming") {
      DeprecateApplicationMain()
      DisableOutwardActorInference()
      DynamicActorIsolation()
      FullTypedThrows()
      GlobalConcurrency()
      ImportObjcForwardDeclarations()
      InferSendableFromCaptures()
      InternalImportsByDefault()
      IsolatedDefaultValues()
    }
  }
)
.supportedPlatforms {
  WWDC2023()
}
.defaultLocalization(.english)
