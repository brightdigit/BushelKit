//
// BushelFactoryTests.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelFactoryTests: TestTarget {
  var dependencies: any Dependencies {
    // BushelLocalization()
    BushelFactory()
    BushelTestUtilities()
    BushelCoreWax()
    BushelMachineWax()
  }
}
