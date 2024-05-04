//
// BushelHubMacOS.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelHubMacOS: Product, Target {
  var dependencies: any Dependencies {
    BushelHub()
    BushelMacOSCore()
  }
}
