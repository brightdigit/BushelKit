//
// EnvironmentValue.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol EnvironmentValue: LosslessStringConvertible {
  static var `default`: Self { get }
}

extension Bool: EnvironmentValue {
  public static var `default`: Bool {
    false
  }
}