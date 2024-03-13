//
// SPFontsDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPFontsDataType

public struct SPFontsDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case enabled
    case path
    case type
    case typefaces
    case valid
  }

  public let name: String
  public let enabled: PrivateFramework
  public let path: String
  public let type: TypeEnum
  public let typefaces: [Typeface]
  public let valid: PrivateFramework

  // swiftlint:disable:next line_length
  public init(name: String, enabled: PrivateFramework, path: String, type: TypeEnum, typefaces: [Typeface], valid: PrivateFramework) {
    self.name = name
    self.enabled = enabled
    self.path = path
    self.type = type
    self.typefaces = typefaces
    self.valid = valid
  }
}
