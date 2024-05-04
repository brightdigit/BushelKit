//
// BushelVirtualization.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelVirtualization: Target {
  var dependencies: any Dependencies {
    BushelLibraryMacOS()
    BushelMachineMacOS()
    BushelHubMacOS()
    BushelSystem()
  }
}
