//
// BushelHubMacOS.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelHubMacOS: Target {
  var dependencies: any Dependencies {
    BushelHub()
    BushelMacOSCore()
  }
}
