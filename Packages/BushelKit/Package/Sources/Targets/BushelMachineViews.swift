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
    BushelSessionUI()
    BushelMachineEnvironment()
    BushelMarketEnvironment()
  }
}
