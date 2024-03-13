//
// SPAirPortDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPAirPortDataType

public struct SPAirPortDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case spairportSoftwareInformation = "spairport_software_information"
  }

  public let spairportSoftwareInformation: SpairportSoftwareInformation

  public init(spairportSoftwareInformation: SpairportSoftwareInformation) {
    self.spairportSoftwareInformation = spairportSoftwareInformation
  }
}
