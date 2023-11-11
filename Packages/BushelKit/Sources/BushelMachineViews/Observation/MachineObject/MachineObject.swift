//
// MachineObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelDataCore
  import BushelLocalization
  import BushelLogging
  import BushelMachine

  import BushelMachineData
  import BushelSessionUI
  import BushelViewsCore
  import SwiftData
  import SwiftUI

  @Observable
  class MachineObject: LoggerCategorized {
    typealias Machine = (any BushelMachine.Machine)

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

        self.refreshSnapshots()
      }
    }

    var sessionViewable: (any Sessionable<ScreenSettings>)? {
      assert(machine is (any Sessionable<ScreenSettings>))
      return machine as? (any Sessionable<ScreenSettings>)
    }

    var state: MachineState = .stopped
    var canStart: Bool = false
    var canStop: Bool = false
    var canPause: Bool = false
    var canResume: Bool = false
    var canRequestStop: Bool = false

    var selectedSnapshot: Snapshot.ID?
    var updatingSnapshotMetadata = false

    var confirmingRemovingSnapshot: Snapshot?
    var presentDeleteConfirmation = false

    var confirmingRestoreSnapshot: Snapshot?
    var presentRestoreConfirmation = false

    var exportingSnapshot: (Snapshot, CodablePackageDocument<MachineConfiguration>)?
    var presentExportingSnapshot = false

    var entry: MachineEntry
    var snapshotIDs = [Snapshot.ID]()
    let label: MetadataLabel

    var currentOperation: MachineOperation?

    @ObservationIgnored
    var observationID: UUID?

    let modelContext: ModelContext

    let systemManager: any MachineSystemManaging

    let snapshotFactory: any SnapshotProvider

    weak var parent: MachineObjectParent?

    var error: MachineError? {
      get {
        assert(self.parent != nil)
        return self.parent?.error
      }
      set {
        assert(self.parent != nil)
        self.parent?.error = newValue
      }
    }

    internal init(
      parent: MachineObjectParent,
      machine: MachineObject.Machine,
      entry: MachineEntry,
      label: MetadataLabel,
      modelContext: ModelContext,
      systemManager: MachineSystemManaging,
      snapshotFactory: any SnapshotProvider
    ) {
      self.parent = parent
      self.machine = machine
      self.entry = entry
      self.label = label
      self.modelContext = modelContext
      self.systemManager = systemManager
      self.snapshotFactory = snapshotFactory

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
    func machineUpdated(_ source: Machine) {
      self.state = source.state
      self.canStart = source.canStart
      self.canStop = source.canStop
      self.canPause = source.canPause
      self.canResume = source.canResume
      self.canRequestStop = source.canRequestStop
    }

    func writeConfigurationAt(_ url: URL) throws {
      let configuraton = machine.configuration
      let data = try JSON.encoder.encode(configuraton)
      let configurationFileURL = url.appendingPathComponent(URL.bushel.paths.machineJSONFileName)
      try data.write(to: configurationFileURL)
    }

    deinit {
      self.machine.removeObservation(withID: observationID)
    }
  }

  extension MachineObject {
    convenience init(
      parent: MachineObjectParent,
      configuration: MachineObjectConfiguration
    ) async throws {
      let components = try await MachineObjectComponents(
        configuration: configuration
      )
      let entry: MachineEntry = try await .basedOnComponents(components)
      self.init(
        parent: parent,
        machine: components.machine,
        entry: entry,
        label: components.label,
        modelContext: configuration.modelContext,
        systemManager: configuration.systemManager,
        snapshotFactory: configuration.snapshotFactory
      )
    }
  }

#endif
