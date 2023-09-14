//
// MachineSystemManaging.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

public protocol MachineSystemManaging {
  func resolve(_ id: VMSystemID) -> any MachineSystem
}

public extension MachineSystemManaging where Self: LoggerCategorized {
  static var loggingCategory: BushelLogging.Loggers.Category {
    .library
  }
}

public extension MachineSystemManaging {
  func machine(contentOf url: URL) throws -> any Machine {
    let configuration: MachineConfiguration
    configuration = try MachineConfiguration(contentsOf: url)
    let system = self.resolve(configuration.vmSystem)
    return try system.machine(at: url, withConfiguration: configuration)
  }
}
