//
// UInt64+Make.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public extension UInt64 {
  static func makeGigaByte(_ num: Int) -> Self {
    .init(num * 1024 * 1024 * 1024)
  }
}
