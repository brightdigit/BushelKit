//
// Data.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public extension Data {
  static func random(ofLength length: Int = 16) -> Data {
    let bytes = (0 ..< length).map { _ in
      UInt8.random(in: 0 ... .max)
    }
    return Data(bytes)
  }
}
