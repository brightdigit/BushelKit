//
// BushelHubMacOS.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelHubMacOS: Target {
  var dependencies: any Dependencies {
    BushelHub()
    BushelMacOSCore()
  }
}
