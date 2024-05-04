//
// Index.swift
// Copyright (c) 2024 BrightDigit.
//

import PackageDescription

let package = Package(
  entries: {
    BushelUITests()
    BushelLibraryApp()
    BushelMachineApp()
    BushelSettingsApp()
    BushelApp()
    BushelService()
  },
  testTargets: {
    BushelServiceTests()
    BushelSessionTests()
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
