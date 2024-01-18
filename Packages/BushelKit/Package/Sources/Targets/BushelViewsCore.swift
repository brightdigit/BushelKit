//
// BushelViewsCore.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelViewsCore: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelLocalization()
    BushelUT()
  }
}
