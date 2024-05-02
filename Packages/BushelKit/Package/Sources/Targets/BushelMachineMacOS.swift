//
// BushelMachineMacOS.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMachineMacOS: Target {
  var dependencies: any Dependencies {
    BushelMachine()
    BushelMacOSCore()
    BushelScreenCore()
  }
}
