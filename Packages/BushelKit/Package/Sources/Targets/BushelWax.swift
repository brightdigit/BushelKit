//
// BushelWax.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelWax: Target {
  var dependencies: any Dependencies {
    BushelHub()
    BushelSystem()
    BushelMacOSCore()
  }
}
