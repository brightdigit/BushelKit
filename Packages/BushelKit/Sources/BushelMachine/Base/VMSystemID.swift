//
// VMSystemID.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct VMSystemID: ExpressibleByStringInterpolation, Codable, Hashable {
  public typealias StringLiteralType = String

  let rawValue: String
  public init(stringLiteral value: String) {
    rawValue = value
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(rawValue)
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    rawValue = try container.decode(String.self)
  }
}
