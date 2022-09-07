//
// OperatingSystemDetails.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public struct OperatingSystemDetails: Codable {
  public init(type: OperatingSystemDetails.System, version: OperatingSystemVersion, buildVersion: String) {
    self.type = type
    self.version = version
    self.buildVersion = buildVersion
  }

  public enum System: String, Codable {
    case macOS
  }

  public let type: System
  public let version: OperatingSystemVersion
  public let buildVersion: String
}
