//
// BushelFactory.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct BushelFactory: Product, Target {
  var dependencies: any Dependencies {
    // BushelLocalization()
    BushelCore()
    BushelMachine()
    BushelLibrary()
    BushelLogging()
    // BushelData()
  }
}
