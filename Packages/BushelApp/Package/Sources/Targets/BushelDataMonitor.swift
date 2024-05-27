//
// BushelDataMonitor.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelDataMonitor: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
  }
}
