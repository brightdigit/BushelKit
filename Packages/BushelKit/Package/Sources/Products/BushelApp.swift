//
// BushelApp.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelApp: Product, Target {
  var dependencies: any Dependencies {
    BushelViews()
    BushelVirtualization()
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
