//
// MachineObject.swift
// Copyright (c) 2024 BrightDigit.
//

// swiftlint:disable file_length

#if canImport(SwiftUI)
  import BushelCore
  import BushelDataCore
  import BushelLocalization
  import BushelLogging
  import BushelMachine
  import BushelMachineData
  import BushelScreenCore
  import BushelViewsCore
  import Combine
  import DataThespian
  import RadiantDocs
  import SwiftData
  import SwiftUI

  #warning("Refactor into smaller pieces")
  @MainActor
  @Observable
  internal final class MachineObject: Loggable, Sendable {
    typealias Machine = (any BushelMachine.Machine)

    var machine: Machine {
      willSet {
        machine.removeObservation(withID: observationID)

        self.observationID = newValue.beginObservation { change in
          Task { @MainActor in
            self.machineUpdated(change)
          }
        }

        Task {
          await self.refreshSnapshots()
        }
      }
    }

    var sessionViewable: (any Sessionable<ScreenSettings>)? {
      assert(machine is (any Sessionable<ScreenSettings>))
      return machine as? (any Sessionable<ScreenSettings>)
    }

    var state: MachineState = .stopped
    var canStart = false
    var canStop = false
    var canPause = false
    var canResume = false
    var canRequestStop = false

    var selectedSnapshot: Snapshot.ID?
    var updatingSnapshotMetadata = false

    var confirmingRemovingSnapshot: Snapshot?
    var presentDeleteConfirmation = false

    var confirmingRestoreSnapshot: Snapshot?
    var presentRestoreConfirmation = false

    var exportingSnapshot: (Snapshot, CodablePackageDocument<MachineConfiguration>)?
    var presentExportingSnapshot = false

    var name: String
    var model: ModelID<MachineEntry>
    var snapshotIDs = [Snapshot.ID]()
    var latestSnapshots: [Snapshot]?
    let label: MetadataLabel

    var currentOperation: MachineOperation?

    @ObservationIgnored
    var observationID: UUID?

    let database: any Database

    let systemManager: any MachineSystemManaging

    let snapshotFactory: any SnapshotProvider

    let databaseChangePublicist: AnyPublisher<any DatabaseChangeSet, Never>

    var cancellable: AnyCancellable?

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
      name: String,
      model: ModelID<MachineEntry>,
      label: MetadataLabel,
      database: any Database,
      systemManager: any MachineSystemManaging,
      snapshotFactory: any SnapshotProvider,
      databaseChangePublicist: AnyPublisher<any DatabaseChangeSet, Never>
    ) {
      self.parent = parent
      self.machine = machine
      self.model = model
      self.label = label
      self.database = database
      self.systemManager = systemManager
      self.snapshotFactory = snapshotFactory
      self.databaseChangePublicist = databaseChangePublicist
      self.name = name

      self.observationID = machine.beginObservation { change in
        Task { @MainActor in
          self.machineUpdated(change)
        }
      }

      self.cancellable = self.databaseChangePublicist.compactMap { update in
        Self.logger.debug("Received Database Update")
        return update.update(contains: ["SnapshotEntry"]) ? () : nil
      }
      .receive(on: DispatchQueue.main)
      .sink {
        Task {
          await self.refreshSnapshots()
        }
      }
    }

    // swiftlint:disable:next cyclomatic_complexity
    @MainActor func machineUpdated(_ update: MachineChange) {
      if let properties = update.properties {
        self.machineUpdated(properties)
      }
      if case let .property(property) = update.event {
        let type = type(of: property)
        switch type.property {
        case .state:
          self.state = property.getValue() ?? self.state
        case .canStart:
          self.canStart = property.getValue() ?? self.canStart
        case .canStop:
          self.canStop = property.getValue() ?? self.canStop
        case .canPause:
          self.canPause = property.getValue() ?? self.canPause
        case .canResume:
          self.canResume = property.getValue() ?? self.canResume
        case .canRequestStop:
          self.canRequestStop = property.getValue() ?? self.canRequestStop
        }
      }
    }

    @MainActor
    func machineUpdated(_ source: MachineProperties) {
      self.state = source.state
      self.canStart = source.canStart
      self.canStop = source.canStop
      self.canPause = source.canPause
      self.canResume = source.canResume
      self.canRequestStop = source.canRequestStop
    }

    func writeConfigurationAt(_ url: URL) async throws {
      let configuraton = await machine.updatedConfiguration
      let data = try JSON.encoder.encode(configuraton)
      let configurationFileURL = url.appendingPathComponent(URL.bushel.paths.machineJSONFileName)
      try data.write(to: configurationFileURL)
    }

    private nonisolated func removeObservation() {
      Task {
        let machine = await self.machine
        Task { @MainActor in
          machine.removeObservation(withID: observationID)
        }
      }
    }

    deinit {
      self.removeObservation()
    }
  }

  extension MachineObject {
    var navigationTitle: String {
      "\(self.name) (\(self.state))"
    }

    convenience init(
      id: String,
      parent: any MachineObjectParent,
      configuration: MachineObjectConfiguration
    ) async throws {
      let components = try await MachineObjectComponents(
        configuration: configuration
      )
      let name = components.configuration.url.deletingPathExtension().lastPathComponent
      let model: ModelID<MachineEntry> = try await MachineEntry.basedOnComponents(components)
      let databaseChangePublicist = configuration.databasePublisherFactory(id).eraseToAnyPublisher()
      self.init(
        parent: parent,
        machine: components.machine,
        name: name,
        model: model,
        label: components.label,
        database: configuration.database,
        systemManager: configuration.systemManager,
        snapshotFactory: configuration.snapshotFactory,
        databaseChangePublicist: databaseChangePublicist
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
