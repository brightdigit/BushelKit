//
// BushelMacOSCore.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMacOSCore: Product, Target {
  var dependencies: any Dependencies {
    BushelCore()
  }
}
