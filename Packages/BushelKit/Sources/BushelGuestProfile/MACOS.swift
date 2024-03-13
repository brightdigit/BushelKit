//
// MACOS.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - MACOS

public struct MACOS: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case the123 = "12.3"
  }

  public let the123: String

  public init(the123: String) {
    self.the123 = the123
  }
}
