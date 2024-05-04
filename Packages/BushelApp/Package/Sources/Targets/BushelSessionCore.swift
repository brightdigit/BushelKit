//
// BushelSessionCore.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelSessionCore: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelMessage()
  }
}
