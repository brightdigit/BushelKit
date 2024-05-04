//
// BushelData.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelData: Target {
  var dependencies: any Dependencies {
    BushelLibraryData()
    BushelMachineData()
  }
}
