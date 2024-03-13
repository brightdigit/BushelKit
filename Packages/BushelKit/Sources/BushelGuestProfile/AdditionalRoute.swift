//
// AdditionalRoute.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - AdditionalRoute

public struct AdditionalRoute: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case destinationAddress = "DestinationAddress"
    case subnetMask = "SubnetMask"
  }

  public let destinationAddress: String
  public let subnetMask: String

  public init(destinationAddress: String, subnetMask: String) {
    self.destinationAddress = destinationAddress
    self.subnetMask = subnetMask
  }
}
