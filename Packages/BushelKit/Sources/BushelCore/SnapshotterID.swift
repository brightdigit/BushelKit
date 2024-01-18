//
// SnapshotterID.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct SnapshotterID: ExpressibleByStringInterpolation,
  Codable,
  Hashable,
  RawRepresentable,
  CustomStringConvertible {
  public typealias StringLiteralType = String

  public let rawValue: String

  public var description: String {
    rawValue
  }

  public init(rawValue value: String) {
    rawValue = value
  }

  public init(stringLiteral value: String) {
    rawValue = value
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    rawValue = try container.decode(String.self)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(rawValue)
  }
}
