//
// WWDC2023.swift
// Copyright (c) 2024 BrightDigit.
//

import PackageDescription

struct WWDC2023: PlatformSet {
  var body: any SupportedPlatforms {
    SupportedPlatform.macOS(.v14)
    SupportedPlatform.iOS(.v17)
    SupportedPlatform.watchOS(.v10)
    SupportedPlatform.tvOS(.v17)
    SupportedPlatform.visionOS(.v1)
    SupportedPlatform.macCatalyst(.v17)
  }
}
