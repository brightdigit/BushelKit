//
// MachineSystemManager.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

public class MachineSystemManager: MachineSystemManaging, LoggerCategorized {
  let implementations: [VMSystemID: any MachineSystem]

  public init(_ implementations: [any MachineSystem]) {
    self.implementations = .init(
      uniqueKeysWithValues: implementations.map {
        ($0.id, $0)
      }
    )
  }

  public func resolve(_ id: VMSystemID) -> any MachineSystem {
    guard let implementations = implementations[id] else {
      Self.logger.critical("Unknown system: \(id.rawValue)")
      preconditionFailure("")
    }

    return implementations
  }
}
