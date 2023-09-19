//
// BushelMachineTests.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelMachineTests: TestTarget {
  var dependencies: any Dependencies {
    BushelMachine()
    BushelTestsCore()
  }
}
