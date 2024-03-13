//
// EnvironmentValue.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol EnvironmentValue: LosslessStringConvertible, Sendable {
  static var `default`: Self { get }
}

extension Bool: EnvironmentValue {
  public static var `default`: Bool {
    false
  }
}
