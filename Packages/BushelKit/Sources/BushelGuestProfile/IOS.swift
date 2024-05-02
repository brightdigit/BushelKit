//
// IOS.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - IOS

public struct IOS: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case the155 = "15.5"
  }

  public let the155: String

  public init(the155: String) {
    self.the155 = the155
  }
}
