//
// BushelLibraryTests.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelLibraryTests: TestTarget {
  var dependencies: any Dependencies {
    BushelLibrary()
    BushelCoreWax()
    BushelLibraryWax()
    BushelTestUtlities()
  }
}
