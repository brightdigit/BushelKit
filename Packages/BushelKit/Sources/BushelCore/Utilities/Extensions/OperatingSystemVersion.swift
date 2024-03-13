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

  var macOSReleaseName: String? {
    Self.macOSReleaseName(majorVersion: majorVersion)
  }

  static func macOSReleaseName(majorVersion: Int) -> String? {
    Self.codeNames[majorVersion]
  }
}
