//
// BushelLibrary.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelLibrary: Product, Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelCore()
    BushelMacOSCore()
    // BushelAccessibility()
  }
}
