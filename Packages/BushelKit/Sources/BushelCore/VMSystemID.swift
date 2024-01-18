//
// VMSystemID.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct VMSystemID: ExpressibleByStringInterpolation, Codable, Hashable, RawRepresentable {
  public typealias StringLiteralType = String

  public let rawValue: String
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
