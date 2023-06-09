//
// VMSystemID.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelVirtualization
import Foundation

public extension VMSystemID {
  static let macOS: VMSystemID = "macOSApple"
}

public extension MachineSpecification {
  static func defaultForSystem(_ system: VMSystemID = .macOS) -> MachineSpecification {
    guard let imageManager = AnyImageManagers.imageManager(forSystem: system) else {
      preconditionFailure()
    }
    return imageManager.defaultSpecifications()
  }
}

public extension Machine {
  init(system: VMSystemID = .macOS) {
    self.init(specification: .defaultForSystem(system))
  }
}
