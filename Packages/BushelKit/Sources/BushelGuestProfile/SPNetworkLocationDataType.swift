//
// SPNetworkLocationDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPNetworkLocationDataType

public struct SPNetworkLocationDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case spnetworklocationIsActive = "spnetworklocation_isActive"
    case spnetworklocationServices = "spnetworklocation_services"
  }

  public let name: String
  public let spnetworklocationIsActive: PrivateFramework
  public let spnetworklocationServices: [SpnetworklocationService]

  // swiftlint:disable:next line_length
  public init(name: String, spnetworklocationIsActive: PrivateFramework, spnetworklocationServices: [SpnetworklocationService]) {
    self.name = name
    self.spnetworklocationIsActive = spnetworklocationIsActive
    self.spnetworklocationServices = spnetworklocationServices
  }
}
