//
// BushelMachineMessage.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMachineMessage: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelMessageCore()
    BushelMachineData()
  }
}
