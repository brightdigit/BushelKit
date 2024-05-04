//
// BushelCore.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelCore: Product, Target {
  var dependencies: any Dependencies {
    OperatingSystemVersion()
  }
}
