//
// BushelCoreTestError.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelTestUtilities

struct BushelCoreTestError: MockError {
  static let database = Self(value: "database")
  static let accessDenied = Self(value: "accessDenied")

  let value: String
}
