//
// BushelMachineViews.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMachineViews: Target {
  var dependencies: any Dependencies {
    BushelMachineData()
    BushelLogging()
    BushelUT()
    BushelLocalization()
    BushelViewsCore()
    BushelScreenCore()
    BushelFactoryViews()
    BushelMachineEnvironment()
    BushelMarketEnvironment()
  }
}
