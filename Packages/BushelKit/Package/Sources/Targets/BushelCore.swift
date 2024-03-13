//
// BushelCore.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelCore: Target {
  var dependencies: any Dependencies {
    OperatingSystemVersion()
  }
}
