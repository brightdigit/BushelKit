//
// DocumentObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelDataCore
  import BushelDataMonitor
  import BushelLogging
  import BushelMachine
  import Combine
  import SwiftData
  import SwiftUI

  @MainActor
  @Observable
  internal final class DocumentObject: Loggable, MachineObjectParent, Sendable {
    var url: URL?
    var alertIsPresented = false
    var error: MachineError? {
      didSet {
        alertIsPresented = (error != nil) || alertIsPresented
      }
    }

    var machineObject: MachineObject?

    var canSaveSnapshot: Bool {
      url != nil && machineObject != nil
    }

    @ObservationIgnored
    var database: (any Database)?

    @ObservationIgnored
    var systemManager: (any MachineSystemManaging)?

    var currentOperation: MachineOperation? {
      get {
        self.machineObject?.currentOperation
      }
      set {
        assert(self.machineObject != nil)
        self.machineObject?.currentOperation = newValue
      }
    }

    var title: String {
      self.machineObject?.entry.name ??
        self.url?
        .deletingPathExtension()
        .lastPathComponent ??
        "Loading Machine..."
    }

    func beginLoadingURL(
      _ url: URL?,
      withDatabase database: any Database,
      restoreImageDBfrom: @escaping @Sendable (any Database) -> any InstallerImageRepository,
      snapshotFactory: any SnapshotProvider,
      using systemManager: any MachineSystemManaging,
      _ labelProvider: @escaping MetadataLabelProvider,
      databasePublisherFactory: @escaping @Sendable (String) -> any Publisher<any DatabaseChangeSet, Never>
    ) {
      guard let url else {
        Self.logger.info("No url to load.")
        return
      }
      Task {
        await self
          .loadURL(
            url,
            withDatabase: database,
            restoreImageDBfrom: restoreImageDBfrom,
            snapshotFactory: snapshotFactory,
            using: systemManager,
            labelProvider,
            databasePublisherFactory: databasePublisherFactory
          )
      }
    }

    private func loadURL(
      _ url: URL,
      withDatabase database: any Database,
      restoreImageDBfrom: @escaping (any Database) -> any InstallerImageRepository,
      snapshotFactory: any SnapshotProvider,
      using systemManager: any MachineSystemManaging,
      _ labelProvider: @escaping MetadataLabelProvider,
      databasePublisherFactory: @escaping @Sendable (String) -> any Publisher<any DatabaseChangeSet, Never>
    ) async {
      Self.logger.info("Loading Machine at \(url)")
      self.database = database
      self.systemManager = systemManager
      do {
        let machineObject = try await MachineObject(
          id: "machine",
          parent: self,
          configuration: .init(
            url: url,
            database: database,
            systemManager: systemManager,
            snapshotterFactory: snapshotFactory,
            installerImageRepositoryFrom: restoreImageDBfrom,
            labelProvider: labelProvider,
            databasePublisherFactory: databasePublisherFactory
          )
        )
        self.machineObject = machineObject
        self.url = url
        try await machineObject.syncronizeSnapshots(at: url, options: .init())
      } catch {
        Self.logger.error("Could not open \(url, privacy: .public): \(error, privacy: .public)")
        self.error = assertionFailure(error: error) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
      }
    }

    func beginSyncronizing() {
      guard let url = self.url else {
        let error = MachineError.missingProperty(.url)
        Self.logger.error("Missing url: \(error)")
        assertionFailure(error: error)
        self.error = error
        return
      }
      guard let machine = self.machineObject else {
        let error = MachineError.missingProperty(.machine)
        Self.logger.error("Missing machine: \(error)")
        assertionFailure(error: error)
        self.error = error
        return
      }
      Task {
        do {
          try await machine.syncronizeSnapshots(at: url, options: .init())
        } catch {
          Self.logger.error("Unable to complete syncronize: \(error.localizedDescription)")
        }
      }
    }

    func beginSavingSnapshot(_ request: SnapshotRequest) {
      self.beginSavingSnapshot(request, options: [])
    }

    func beginSavingSnapshot(_ request: SnapshotRequest, options: SnapshotOptions) {
      guard let url = self.url else {
        let error = MachineError.missingProperty(.url)
        Self.logger.error("Missing url: \(error)")
        assertionFailure(error: error)
        self.error = error
        return
      }
      guard let machine = self.machineObject else {
        let error = MachineError.missingProperty(.machine)
        Self.logger.error("Missing machine: \(error)")
        assertionFailure(error: error)
        self.error = error
        return
      }
      machine.beginSavingSnapshot(request, options: options, at: url)
    }
  }

#endif
