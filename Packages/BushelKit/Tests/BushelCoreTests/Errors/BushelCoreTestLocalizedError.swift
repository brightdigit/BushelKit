//
// BushelCoreTestLocalizedError.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelTestUtlities

struct BushelCoreTestLocalizedError: MockLocalizedError {
  static let sample = Self(value: "sample")

  let value: String
}
