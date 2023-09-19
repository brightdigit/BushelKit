//
// BushelCoreTestLocalizedError.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelTestsCore

struct BushelCoreTestLocalizedError: MockLocalizedError {
  static let sample = Self(value: "sample")

  let value: String
}
