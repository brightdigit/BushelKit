//
// BushelCoreTestError.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelCoreTestError: MockError {
  static let database = Self(value: "database")
  static let accessDenied = Self(value: "accessDenied")

  let value: String
}
