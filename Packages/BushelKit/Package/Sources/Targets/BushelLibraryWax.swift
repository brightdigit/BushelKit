//
// BushelLibraryWax.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelLibraryWax: Target {
  var dependencies: any Dependencies {
    BushelLibrary()
    BushelMacOSCore()
  }
}
