//
//  MachineInventory.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

public import BushelLogging
public import Foundation
public import Observation

@Observable
public final class MachineInventory: Sendable, Loggable  {
  public struct Observer: Sendable {
    public let machine: any Machine
    private let observationID: UUID
    public private(set) var properties: MachineProperties

    internal init(machine: any Machine, observationID: UUID, properties: MachineProperties? = nil) {
      self.machine = machine
      self.observationID = observationID
      self.properties = properties ?? .initial
    }

    fileprivate mutating  func updatedProperties(from changes: MachineChange) {
      if let properties = changes.properties {
        self.properties = properties
      }

      if case let .property(property) = changes.event {
        self.properties = self.properties.updateProperty(property)
      }
    }
  }

  public static let shared = MachineInventory()
  public static var loggingCategory: BushelLogging.Category {
    .observation
  }

  @MainActor
  public private(set) var observers: [UUID: Observer] = [:]

  private init() {
  }

  internal nonisolated func registerMachine(_ machine: any Machine, withID id: UUID) {
    Self.logger.debug(
      "Registering machine \(machine.initialConfiguration.operatingSystemVersion.description) with ID \(id)"
    )
    let observationID = machine.beginObservation { [self] machineChange in
      self.machineWithID(id, updatedTo: machineChange)
    }
    Task { @MainActor in
      self.observers[id] = .init(machine: machine, observationID: observationID)
    }
  }

  nonisolated private func machineWithID(_ id: UUID, updatedTo changes: MachineChange) {
    Task { @MainActor in
      self.onMachine(withID: id, updatedTo: changes)
    }
  }

  @MainActor
  private func onMachine(withID id: UUID, updatedTo changes: MachineChange) {
    Self.logger.debug("Updating machine with ID \(id) from \(changes.event.description)")
    assert(self.observers[id] != nil)
    self.observers[id]?.updatedProperties(from: changes)
  }
}
