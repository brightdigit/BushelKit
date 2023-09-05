//
// BushelLibraryEnvironment.swift
// Copyright (c) 2023 BrightDigit.
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
