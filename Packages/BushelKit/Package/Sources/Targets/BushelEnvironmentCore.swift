//
// BushelEnvironmentCore.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelEnvironmentCore: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
  }
}
