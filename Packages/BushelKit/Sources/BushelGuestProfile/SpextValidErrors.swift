//
// SpextValidErrors.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SpextValidErrors

public struct SpextValidErrors: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case validationFailures = "Validation Failures"
  }

  public let validationFailures: ValidationFailures

  public init(validationFailures: ValidationFailures) {
    self.validationFailures = validationFailures
  }
}
