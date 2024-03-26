//
// MachineSystemManager.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

/// Implementation of a ``MachineSystemManaging``
public class MachineSystemManager: MachineSystemManaging, Loggable {
  let implementations: [VMSystemID: any MachineSystem]

  /// Creates a ``MachineSystemManager`` based on the list of implementations.
  /// - Parameter implementations: Array of ``MachineSystem``
  public init(_ implementations: [any MachineSystem]) {
    self.implementations = .init(
      uniqueKeysWithValues: implementations.map {
        ($0.id, $0)
      }
    )
  }

  /// Resolve the ``MachineSystem`` based on the ``VMSystemID``
  /// - Parameter id: id of the system to resolve.
  /// - Returns: The resulting ``MachineSystem``
  public func resolve(_ id: VMSystemID) -> any MachineSystem {
    guard let implementation = implementations[id] else {
      Self.logger.critical("Unknown system: \(id.rawValue)")
      preconditionFailure("Unknown system: \(id.rawValue)")
    }

    return implementation
  }
}
