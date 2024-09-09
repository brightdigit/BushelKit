//
// BushelDataCore.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelDataCore: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    OperatingSystemVersion()
    DataThespian()
  }
}
