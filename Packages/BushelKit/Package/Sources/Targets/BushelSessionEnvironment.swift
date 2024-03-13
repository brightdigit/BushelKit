//
// BushelSessionEnvironment.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelSessionEnvironment: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelMessageCore()
    BushelSessionCore()
  }
}
