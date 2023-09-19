//
// MachineObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelDataCore
  import BushelLogging
  import BushelMachine

  import BushelMachineData
  import BushelSessionUI
  import SwiftData
  import SwiftUI

  @Observable
  class MachineObject: LoggerCategorized {
    typealias Machine = BushelMachine.Machine

    var machine: Machine {
      willSet {
        machine.removeObservation(withID: observationID)
      }
      didSet {
        self.observationID = machine.beginObservation { change in
          Task { @MainActor in
            self.machineUpdated(change)
          }
        }

        Task { @MainActor in
          self.machineUpdated(machine)
        }
      }
    }

    var sessionViewable: (any Sessionable)? {
      assert(machine is (any Sessionable))
      return machine as? (any Sessionable)
    }

    var state: MachineState = .stopped
    var canStart: Bool = false
    var canStop: Bool = false
    var canPause: Bool = false
    var canResume: Bool = false
    var canRequestStop: Bool = false

    var entry: MachineEntry

    let label: MetadataLabel

    @ObservationIgnored
    var observationID: UUID?

    @ObservationIgnored
    var modelContext: ModelContext?

    @ObservationIgnored
    var systemManager: (any MachineSystemManaging)?

    internal init(
      machine: MachineObject.Machine,
      entry: MachineEntry,
      label: MetadataLabel,
      modelContext: ModelContext? = nil,
      systemManager: MachineSystemManaging? = nil
    ) {
      self.machine = machine
      self.entry = entry
      self.label = label
      self.modelContext = modelContext
      self.systemManager = systemManager

      self.observationID = machine.beginObservation { change in
        Task { @MainActor in
          self.machineUpdated(change)
        }
      }
      Task { @MainActor in
        self.machineUpdated(machine)
      }
    }

    @MainActor
    func machineUpdated(_ update: MachineChange) {
      self.machineUpdated(update.source)
    }

    @MainActor
    func machineUpdated(_ source: BushelMachine.Machine) {
      self.state = source.state
      self.canStart = source.canStart
      self.canStop = source.canStop
      self.canPause = source.canPause
      self.canResume = source.canResume
      self.canRequestStop = source.canRequestStop
    }

    deinit {
      self.machine.removeObservation(withID: observationID)
    }
  }

  extension MachineObject {
    convenience init(
      configuration: MachineObjectConfiguration
    ) throws {
      let components = try MachineObjectComponents(
        configuration: configuration
      )
      let entry: MachineEntry = try .basedOnComponents(components)
      self.init(
        machine: components.machine,
        entry: entry,
        label: components.label,
        modelContext: configuration.modelContext,
        systemManager: configuration.systemManager
      )
    }
  }

#endif
