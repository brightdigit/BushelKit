//
// BushelSession.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelSession: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelSessionCore()
    BushelSessionEnvironment()
    BushelMachineMessage()
  }
}
