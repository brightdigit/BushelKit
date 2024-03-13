//
// SPRawCameraDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPRawCameraDataType

public struct SPRawCameraDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
  }

  public let name: String

  public init(name: String) {
    self.name = name
  }
}
