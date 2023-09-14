//
// BushelCoreTestLocalizedError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelCoreTestLocalizedError: MockLocalizedError {
  static let sample = Self(value: "sample")

  let value: String
}
