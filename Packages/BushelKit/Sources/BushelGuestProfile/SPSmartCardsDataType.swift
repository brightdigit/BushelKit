//
// SPSmartCardsDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPSmartCardsDataType

public struct SPSmartCardsDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case the01 = "#01"
    case items = "_items"
  }

  public let name: String
  public let the01: String?
  public let items: [SPRawCameraDataType]?

  public init(name: String, the01: String?, items: [SPRawCameraDataType]?) {
    self.name = name
    self.the01 = the01
    self.items = items
  }
}
