//
// BushelLibraryMacOS.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelLibraryMacOS: Target {
  var dependencies: any Dependencies {
    BushelLibrary()
    BushelMacOSCore()
  }
}
