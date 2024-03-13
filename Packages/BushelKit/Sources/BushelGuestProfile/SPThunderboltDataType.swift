//
// SPThunderboltDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPThunderboltDataType

public struct SPThunderboltDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case thunderbolt = "Thunderbolt"
  }

  public let thunderbolt: String

  public init(thunderbolt: String) {
    self.thunderbolt = thunderbolt
  }
}
