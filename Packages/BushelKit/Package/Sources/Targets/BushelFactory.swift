//
// BushelFactory.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct BushelFactory: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelMachine()
    BushelLibrary()
    BushelLogging()
    BushelData()
  }
}
