//
// BushelFactoryViews.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelFactoryViews: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelFactory()
    BushelViewsCore()
    BushelMachineEnvironment()
    RadiantKit()
  }
}
