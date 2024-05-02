//
// BushelService.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelService: Product, Target {
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
    BushelMessage()
  }
}
