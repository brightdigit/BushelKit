//
// Array+MessageTypes.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMessageCore
import Foundation

public extension Array where Element == any Message.Type {
  static var all: [any Message.Type] {
    [Array.machine].flatMap { $0 }
  }
}
