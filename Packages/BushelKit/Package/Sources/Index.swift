//
// Index.swift
// Copyright (c) 2024 BrightDigit.
//

import PackageDescription

let package = Package(
  entries: {
    BushelUITests()
    BushelCommand()
    BushelLibraryApp()
    BushelMachineApp()
    BushelSettingsApp()
    BushelApp()
    BushelService()
    BushelGuestProfile()
  },
  testTargets: {
    BushelCoreTests()
    BushelLibraryTests()
    BushelMachineTests()
    BushelServiceTests()
    BushelSessionTests()
    BushelFactoryTests()
  },
  swiftSettings: {
    SwiftSetting.enableUpcomingFeature("BareSlashRegexLiterals")
    SwiftSetting.enableUpcomingFeature("ConciseMagicFile")
    SwiftSetting.enableUpcomingFeature("ExistentialAny")
    SwiftSetting.enableUpcomingFeature("ForwardTrailingClosures")
    SwiftSetting.enableUpcomingFeature("ImplicitOpenExistentials")
    SwiftSetting.enableUpcomingFeature("StrictConcurrency")
    SwiftSetting.enableUpcomingFeature("DisableOutwardActorInference")
    SwiftSetting.enableUpcomingFeature("DynamicActorIsolation")
    SwiftSetting.enableUpcomingFeature("FullTypedThrows")
    SwiftSetting.enableUpcomingFeature("InternalImportsByDef")
    SwiftSetting.enableUpcomingFeature("InferSendableFromCap")
    SwiftSetting.enableUpcomingFeature("IsolatedDefaultValue")
    SwiftSetting.enableUpcomingFeature("DisableOutwardActorI")
    SwiftSetting.enableUpcomingFeature("ImportObjcForwardDec")
    SwiftSetting.enableUpcomingFeature("DeprecateApplication")
    SwiftSetting.enableExperimentalFeature("StrictConcurrency")
    SwiftSetting.unsafeFlags(["-warn-concurrency", "-enable-actor-data-race-checks"])
  }
)
.supportedPlatforms {
  WWDC2023()
}
.defaultLocalization(.english)
