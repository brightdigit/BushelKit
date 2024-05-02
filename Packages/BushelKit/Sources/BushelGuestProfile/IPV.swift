//
// IPV.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - IPV

public struct IPV: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case configMethod = "ConfigMethod"
  }

  public let configMethod: String

  public init(configMethod: String) {
    self.configMethod = configMethod
  }
}
