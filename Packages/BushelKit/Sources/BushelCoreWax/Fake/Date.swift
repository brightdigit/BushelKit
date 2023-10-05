//
// Date.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public extension Date {
  static func randomPast(asFarBackAs timeInterval: TimeInterval) -> Date {
    Date(timeIntervalSinceNow: .random(in: -timeInterval ... 0))
  }

  static func random(ofLength length: Int = 16) -> Data {
    let bytes = (0 ..< length).map { _ in
      UInt8.random(in: 0 ... .max)
    }
    return Data(bytes)
  }
}
