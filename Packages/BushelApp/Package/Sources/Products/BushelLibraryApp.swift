//
// BushelLibraryApp.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelLibraryApp: Product, Target {
  var dependencies: any Dependencies {
    BushelLibraryViews()
    BushelLibraryMacOS()
  }
}
