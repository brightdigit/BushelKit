//
// BushelMachine.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMachine: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
  }
}
