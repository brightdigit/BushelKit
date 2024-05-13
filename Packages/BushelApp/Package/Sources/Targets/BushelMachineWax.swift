//
// BushelMachineWax.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct BushelMachineWax: Target {
  var dependencies: any Dependencies {
    BushelCoreWax()
    BushelMachine()
  }
}
