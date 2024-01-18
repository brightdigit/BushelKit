//
// BushelHubEnvironment.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct BushelHubEnvironment: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelCore()
    BushelHub()
    BushelLocalization()
  }
}
