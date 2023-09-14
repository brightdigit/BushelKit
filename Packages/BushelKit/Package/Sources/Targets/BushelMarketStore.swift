//
// BushelMarketStore.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelMarketStore: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelMarket()
  }
}
