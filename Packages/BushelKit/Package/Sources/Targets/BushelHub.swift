//
// BushelHub.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct BushelHub: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelCore()
    BushelViewsCore()
  }
}
