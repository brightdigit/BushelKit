//
// BushelMachineEnvironment.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct BushelMachineEnvironment: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelCore()
    BushelMachine()
    BushelDataCore()
    BushelLocalization()
  }
}
