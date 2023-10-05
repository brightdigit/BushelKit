//
// MachineSystemManaging.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

/// A collection of machine systems for managing virtual machines
public protocol MachineSystemManaging {
  /// Resolve the ``MachineSystem`` based on the ``VMSystemID``
  /// - Parameter id: id of the system to resolve.
  /// - Returns: The resulting ``MachineSystem``
  func resolve(_ id: VMSystemID) -> any MachineSystem
}

public extension MachineSystemManaging where Self: LoggerCategorized {
  static var loggingCategory: BushelLogging.Loggers.Category {
    .library
  }
}

public extension MachineSystemManaging {
  /// Resolves the ``MachineSystem`` and ``Machine`` based on the  bundle at the URL.
  /// - Parameter url: Machine bundle URL.
  /// - Returns: The resolved ``Machine``
  func machine(contentOf url: URL) async throws -> any Machine {
    let configuration: MachineConfiguration
    configuration = try MachineConfiguration(contentsOf: url)
    let system = self.resolve(configuration.vmSystemID)
    return try await system.machine(at: url, withConfiguration: configuration)
  }
}
