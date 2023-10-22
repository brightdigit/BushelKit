//
// VZMachine+Observe.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import BushelMacOSCore
  import Foundation
  import SwiftUI
  import Virtualization

  extension VZMachine {
    func notifyObservers(_ event: MachineChange.Event) {
      let update = MachineChange(source: self, event: event)
      #warning("logging-note: why not print every notifiy of machine changes")
      for value in observers.values {
        Task { @MainActor in
          value(update)
        }
      }
    }

    #warning("logging-note: let's have a debug message for remove too")
    @discardableResult
    func removeObservation(withID id: UUID) -> Bool {
      self.observers.removeValue(forKey: id) != nil
    }

    func beginObservation(_ update: @escaping @MainActor (MachineChange) -> Void) -> UUID {
      let id = UUID()
      Self.logger.debug("Begin observations: \(id)")
      self.observers[id] = update
      return id
    }
  }
#endif
