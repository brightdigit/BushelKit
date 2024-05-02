//
// BushelLibrary.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelLibrary: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelCore()
    BushelMacOSCore()
    BushelAccessibility()
  }
}
