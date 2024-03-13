//
// ValidationFailures.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - ValidationFailures

// swiftlint:disable identifier_name
public struct ValidationFailures: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case infoDictionaryMissingRequiredPropertyValue = "Info dictionary missing required property/value"
    case infoDictionaryPropertyValueIsIllegal = "Info dictionary property value is illegal"
  }

  public let infoDictionaryMissingRequiredPropertyValue: [String]
  public let infoDictionaryPropertyValueIsIllegal: [String]

  // swiftlint:disable:next line_length
  public init(infoDictionaryMissingRequiredPropertyValue: [String], infoDictionaryPropertyValueIsIllegal: [String]) {
    self.infoDictionaryMissingRequiredPropertyValue = infoDictionaryMissingRequiredPropertyValue
    self.infoDictionaryPropertyValueIsIllegal = infoDictionaryPropertyValueIsIllegal
  }
}

// swiftlint:enable identifier_name
