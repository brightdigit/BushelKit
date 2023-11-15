//
// BushelLibraryViews.swift
// Copyright (c) 2023 BrightDigit.
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
