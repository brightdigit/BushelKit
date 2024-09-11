//
// BushelSystem.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct BushelSystem: Target {
  var dependencies: any Dependencies {
    BushelMachine()
    BushelLibrary()
    BushelHub()
    BushelHubEnvironment()
    BushelLibraryEnvironment()
    BushelMachineEnvironment()
    RadiantDocs()
  }
}
