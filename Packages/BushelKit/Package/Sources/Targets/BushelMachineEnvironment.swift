//
// BushelMachineEnvironment.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelMachineEnvironment: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelCore()
    BushelMachine()
    BushelLocalization()
  }
}
