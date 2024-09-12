//
// BushelMachineData.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMachineData: Target {
  var dependencies: any Dependencies {
    BushelDataCore()
    BushelMachine()
    BushelLogging()
    DataThespian()
  }
}
