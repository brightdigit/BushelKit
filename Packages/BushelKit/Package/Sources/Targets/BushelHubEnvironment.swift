//
// BushelHubEnvironment.swift
// Copyright (c) 2023 BrightDigit.
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
