//
// BushelMarketViews.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelMarketViews: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelMarket()
    BushelMarketStore()
    BushelMarketEnvironment()
    BushelViewsCore()
  }
}
