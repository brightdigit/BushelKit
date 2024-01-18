//
// BushelMarketEnvironment.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMarketEnvironment: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelMarket()
    BushelEnvironmentCore()
  }
}
