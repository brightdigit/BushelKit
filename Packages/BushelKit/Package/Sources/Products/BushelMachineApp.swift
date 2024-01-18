//
// BushelMachineApp.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMachineApp: Target, Product {
  var dependencies: any Dependencies {
    BushelMachineViews()
    BushelMachineMacOS()
  }
}
