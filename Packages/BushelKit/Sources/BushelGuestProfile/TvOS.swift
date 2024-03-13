//
// TvOS.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - TvOS

public struct TvOS: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case the154 = "15.4"
  }

  public let the154: String

  public init(the154: String) {
    self.the154 = the154
  }
}
