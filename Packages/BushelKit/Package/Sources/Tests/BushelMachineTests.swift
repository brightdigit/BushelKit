//
// BushelMachineTests.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMachineTests: TestTarget {
  var dependencies: any Dependencies {
    BushelMachine()
    BushelMachineWax()
    BushelTestUtilities()
  }
}
