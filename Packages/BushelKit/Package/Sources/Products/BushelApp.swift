//
// BushelApp.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelApp: Product, Target {
  var dependencies: any Dependencies {
    BushelViews()
    BushelVirtualization()
    BushelHubIPSW()
    BushelMachine()
    BushelLibrary()
    BushelSystem()
    BushelData()
    BushelHub()
    BushelFactory()
    BushelMarket()
    BushelWax()
  }
}
