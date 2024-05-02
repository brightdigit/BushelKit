//
// DriverKit.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - DriverKit

public struct DriverKit: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case the214 = "21.4"
  }

  public let the214: String

  public init(the214: String) {
    self.the214 = the214
  }
}
