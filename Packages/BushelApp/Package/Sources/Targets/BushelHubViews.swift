//
// BushelHubViews.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct BushelHubViews: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelCore()
    BushelHub()
    BushelLocalization()
    BushelHubEnvironment()
    BushelLibraryEnvironment()
  }
}
