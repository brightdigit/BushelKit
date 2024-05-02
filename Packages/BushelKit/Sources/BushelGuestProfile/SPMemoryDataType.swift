//
// SPMemoryDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPMemoryDataType

public struct SPMemoryDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case dimmType = "dimm_type"
    case spMemoryDataType = "SPMemoryDataType"
  }

  public let dimmType: ObtainedFrom
  public let spMemoryDataType: String

  public init(dimmType: ObtainedFrom, spMemoryDataType: String) {
    self.dimmType = dimmType
    self.spMemoryDataType = spMemoryDataType
  }
}
