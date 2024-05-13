//
// BushelXPCSession.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelXPCSession: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelSession()
  }
}
