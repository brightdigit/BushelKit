//
// BushelMachineWax.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelMachineWax: Target {
  var dependencies: any Dependencies {
    BushelCoreWax()
    BushelMachine()
  }
}
