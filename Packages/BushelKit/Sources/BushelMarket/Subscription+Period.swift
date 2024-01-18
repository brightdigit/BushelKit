//
// Subscription+Period.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

public extension Subscription {
  struct Period {
    public enum Unit {
      case year
      case month
      case week
      case day
      case unknown(value: Any)
    }

    public init(unit: Unit, value: Int) {
      self.unit = unit
      self.value = value
    }

    let unit: Unit
    let value: Int
  }
}
