//
// MachineObservationCollection.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelLogging
import BushelMachine
import Foundation

actor MachineObservationCollection: Loggable {
  static var loggingCategory: BushelLogging.Category {
    .machine
  }

  private var observers = [UUID: @Sendable (MachineChange) -> Void]()

  func notifyObservers(of update: MachineChange) {
    Self.logger.debug("Updating \(self.observers.count) observer of change: \(update.event)")
    for value in observers.values {
      Task {
        value(update)
      }
    }
  }

  func addObservation(_ closure: @Sendable @escaping (MachineChange) -> Void, withID id: UUID) {
    assert(self.observers[id] == nil)
    self.observers[id] = closure
    Self.logger.debug("Begin observations: \(id)")
  }

  func removeObserver(withID id: UUID) -> Bool {
    let value = self.observers.removeValue(forKey: id)
    assert(value != nil)
    return value != nil
  }
}
