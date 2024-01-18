//
// BushelMarketViews.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMarketViews: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLocalization()
    BushelLogging()
    BushelMarket()
    BushelMarketStore()
    BushelMarketEnvironment()
    BushelViewsCore()
  }
}
