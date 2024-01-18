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
  },
  testTargets: {
    BushelCoreTests()
    BushelLibraryTests()
    BushelMachineTests()
  },
  swiftSettings: {
    SwiftSetting.enableUpcomingFeature("BareSlashRegexLiterals")
    SwiftSetting.enableUpcomingFeature("ConciseMagicFile")
    // .enableUpcomingFeature("ExistentialAny"),
    SwiftSetting.enableUpcomingFeature("ForwardTrailingClosures")
    SwiftSetting.enableUpcomingFeature("ImplicitOpenExistentials")
    SwiftSetting.enableUpcomingFeature("StrictConcurrency")
  }
)
.supportedPlatforms {
  WWDC2023()
}
.defaultLocalization(.english)
