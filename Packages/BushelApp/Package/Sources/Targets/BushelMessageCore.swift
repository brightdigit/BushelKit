//
// BushelMessageCore.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMessageCore: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelDataCore()
  }
}
