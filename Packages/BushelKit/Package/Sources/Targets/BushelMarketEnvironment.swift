//
// BushelMarketEnvironment.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelMarketEnvironment: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelMarket()
  }
}
