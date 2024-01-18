//
// BushelLibraryViews.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelLibraryViews: Target {
  var dependencies: any Dependencies {
    BushelLibrary()
    BushelData()
    BushelLibraryEnvironment()
    BushelLogging()
    BushelUT()
    BushelViewsCore()
    BushelProgressUI()
  }
}
