//
// BushelMachine.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMachine: Product, Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
  }
}
