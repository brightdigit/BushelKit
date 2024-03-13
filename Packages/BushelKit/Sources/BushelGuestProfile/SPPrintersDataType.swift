//
// SPPrintersDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPPrintersDataType

public struct SPPrintersDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case cupsversion
    case status
  }

  public let cupsversion: String
  public let status: String

  public init(cupsversion: String, status: String) {
    self.cupsversion = cupsversion
    self.status = status
  }
}
