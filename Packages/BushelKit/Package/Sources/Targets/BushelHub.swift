//
// BushelHub.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelHub: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelCore()
    BushelViewsCore()
  }
}
