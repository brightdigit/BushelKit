//
// BushelCoreTests.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelCoreTests: TestTarget {
  var dependencies: any Dependencies {
    BushelCore()
    BushelCoreWax()
    BushelTestUtilities()
  }
}
