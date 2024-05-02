//
// SPPrefPaneDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPPrefPaneDataType

public struct SPPrefPaneDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case spprefpaneBundlePath = "spprefpane_bundlePath"
    case spprefpaneIdentifier = "spprefpane_identifier"
    case spprefpaneIsVisible = "spprefpane_isVisible"
    case spprefpaneKind = "spprefpane_kind"
    case spprefpaneSupport = "spprefpane_support"
    case spprefpaneVersion = "spprefpane_version"
  }

  public let name: String
  public let spprefpaneBundlePath: String
  public let spprefpaneIdentifier: String
  public let spprefpaneIsVisible: PrivateFramework
  public let spprefpaneKind: SpprefpaneKind
  public let spprefpaneSupport: SpprefpaneSupport
  public let spprefpaneVersion: String

  // swiftlint:disable:next line_length
  public init(name: String, spprefpaneBundlePath: String, spprefpaneIdentifier: String, spprefpaneIsVisible: PrivateFramework, spprefpaneKind: SpprefpaneKind, spprefpaneSupport: SpprefpaneSupport, spprefpaneVersion: String) {
    self.name = name
    self.spprefpaneBundlePath = spprefpaneBundlePath
    self.spprefpaneIdentifier = spprefpaneIdentifier
    self.spprefpaneIsVisible = spprefpaneIsVisible
    self.spprefpaneKind = spprefpaneKind
    self.spprefpaneSupport = spprefpaneSupport
    self.spprefpaneVersion = spprefpaneVersion
  }
}
