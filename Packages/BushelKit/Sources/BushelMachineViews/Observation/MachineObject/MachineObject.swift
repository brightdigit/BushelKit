//
// MachineObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelDataCore
  import BushelLocalization
  import BushelLogging
  import BushelMachine

  import BushelMachineData
  import BushelScreenCore
  import BushelViewsCore
  import SwiftData
  import SwiftUI

  @Observable
  final class MachineObject: Loggable, Sendable {
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

    let database: any Database

    let systemManager: any MachineSystemManaging

    let snapshotFactory: any SnapshotProvider

    weak var parent: (any MachineObjectParent)?

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
      parent: any MachineObjectParent,
      machine: MachineObject.Machine,
      entry: MachineEntry,
      label: MetadataLabel,
      database: any Database,
      systemManager: any MachineSystemManaging,
      snapshotFactory: any SnapshotProvider
    ) {
      self.parent = parent
      self.machine = machine
      self.entry = entry
      self.label = label
      self.database = database
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
      Task { @MainActor in
        self.machine.removeObservation(withID: observationID)
      }
    }
  }

  extension MachineObject {
    var navigationTitle: String {
      "\(self.entry.name) (\(self.state))"
    }

    convenience init(
      parent: any MachineObjectParent,
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
        database: configuration.database,
        systemManager: configuration.systemManager,
        snapshotFactory: configuration.snapshotFactory
      )
    }
  }

  extension Optional where Wrapped == MachineObject {
    @MainActor func navigationTitle(
      default defaultValue: String
    ) -> String {
      self?.navigationTitle ?? defaultValue
    }
  }

#endif
