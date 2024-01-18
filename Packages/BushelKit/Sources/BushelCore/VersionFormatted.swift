//
// VersionFormatted.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct VersionFormatted {
  public let marketingVersion: String
  public let buildNumberHex: String

  public init(marketingVersion: String, buildNumberHex: String) {
    self.marketingVersion = marketingVersion
    self.buildNumberHex = buildNumberHex
  }
}

extension VersionFormatted {
  init(version: Version) {
    self.init(
      marketingVersion: version.description,
      buildNumberHex: version.buildNumberHex()
    )
  }
}
