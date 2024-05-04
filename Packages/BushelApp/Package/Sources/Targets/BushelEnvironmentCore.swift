//
// BushelEnvironmentCore.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelEnvironmentCore: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
  }
}
