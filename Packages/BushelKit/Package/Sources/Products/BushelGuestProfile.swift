//
// BushelGuestProfile.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct BushelGuestProfile: Product, Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
  }
}
