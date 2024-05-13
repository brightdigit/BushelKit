//
// BushelMarketStore.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMarketStore: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelMarket()
  }
}