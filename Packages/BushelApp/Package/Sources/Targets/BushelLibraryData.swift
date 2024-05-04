//
// BushelLibraryData.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelLibraryData: Target {
  var dependencies: any Dependencies {
    BushelLibrary()
    BushelLogging()
    BushelDataCore()
  }
}
