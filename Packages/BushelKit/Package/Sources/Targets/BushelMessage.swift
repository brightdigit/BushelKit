//
// BushelMessage.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMessage: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelMachineMessage()
  }
}
