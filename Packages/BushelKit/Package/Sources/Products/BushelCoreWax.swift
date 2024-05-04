//
// BushelCoreWax.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct BushelCoreWax: Product, Target {
  var dependencies: any Dependencies {
    BushelCore()
  }
}
