//
// WatchOS.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - WatchOS

public struct WatchOS: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case the85 = "8.5"
  }

  public let the85: String

  public init(the85: String) {
    self.the85 = the85
  }
}
