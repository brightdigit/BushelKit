//
// VirtualizationMachine+Observe.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import BushelMacOSCore
  import Foundation
  import SwiftUI
  import Virtualization

  extension VirtualizationMachine {
    func notifyObservers(_ event: MachineChange.Event) {
      let update = MachineChange(source: self, event: event)
      Self.logger.debug("Updating \(self.observers.count) observer of change: \(event)")
      for value in observers.values {
        Task { @MainActor in
          value(update)
        }
      }
    }

    @discardableResult
    func removeObservation(withID id: UUID) -> Bool {
      Self.logger.debug("Removing Observer")
      return self.observers.removeValue(forKey: id) != nil
    }

    func beginObservation(_ update: @Sendable @escaping @MainActor (MachineChange) -> Void) -> UUID {
      let id = UUID()
      Self.logger.debug("Begin observations: \(id)")
      self.observers[id] = update
      return id
    }
  }
#endif
