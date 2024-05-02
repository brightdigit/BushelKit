//
// SPPowerDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPPowerDataType

public struct SPPowerDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case acPower = "AC Power"
    case sppowerUPSInstalled = "sppower_ups_installed"
  }

  public let name: String
  public let acPower: ACPower?
  public let sppowerUPSInstalled: String?

  public init(name: String, acPower: ACPower?, sppowerUPSInstalled: String?) {
    self.name = name
    self.acPower = acPower
    self.sppowerUPSInstalled = sppowerUPSInstalled
  }
}
