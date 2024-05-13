//
// Subscription+Period.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

extension Subscription {
  public struct Period: Sendable {
    public enum Unit: Sendable {
      case year
      case month
      case week
      case day
      case unknown(value: any Sendable)
    }

    public init(unit: Unit, value: Int) {
      self.unit = unit
      self.value = value
    }

    let unit: Unit
    let value: Int
  }
}
