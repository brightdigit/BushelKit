//
// VMSystemID.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelMachine
import Foundation

public extension VMSystemID {
  static let macOS: VMSystemID = "macOSApple"
}

public extension MachineSpecification {
  static var `default`: MachineSpecification {
    guard let imageManager = AnyImageManagers.imageManager(forSystem: .macOS) else {
      preconditionFailure()
    }
    return imageManager.defaultSpecifications()
  }
}

public extension Machine {
  init() {
    self.init(specification: .default)
  }
}
