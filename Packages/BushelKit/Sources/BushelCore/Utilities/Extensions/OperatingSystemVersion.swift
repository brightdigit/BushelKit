//
// OperatingSystemVersion.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public extension OperatingSystemVersion {
  private static let codeNames: [Int: String] = [
    11: "Big Sur",
    12: "Monterey",
    13: "Ventura",
    14: "Sonoma"
  ]

  private static let minimumVirtualizationMajorVersion = 12

  var macOSReleaseName: String? {
    Self.macOSReleaseName(majorVersion: majorVersion)
  }

  static func macOSReleaseName(majorVersion: Int) -> String? {
    Self.codeNames[majorVersion]
  }

  static func availableMajorVersions(onlyVirtualizationSupported: Bool) -> any Collection<Int> {
    guard onlyVirtualizationSupported else {
      return codeNames.keys
    }
    return codeNames.keys.filter { $0 >= minimumVirtualizationMajorVersion }
  }
}
