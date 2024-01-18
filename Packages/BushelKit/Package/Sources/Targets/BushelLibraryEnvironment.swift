//
// BushelLibraryEnvironment.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct BushelLibraryEnvironment: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelCore()
    BushelLibrary()
    BushelLocalization()
  }
}
