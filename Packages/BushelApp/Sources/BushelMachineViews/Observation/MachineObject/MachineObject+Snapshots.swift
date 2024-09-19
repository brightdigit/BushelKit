//
// MachineObject+Snapshots.swift
// Copyright (c) 2024 BrightDigit.
//

// swiftlint:disable file_length

#if canImport(SwiftUI)
  import BushelCore
  import BushelDataCore
  import BushelLogging
  import BushelMachine
  import BushelMachineData
  import BushelViewsCore
  import DataThespian
  import Foundation
  import RadiantDocs
  import SwiftData

  import SwiftUI

  extension MachineObject {
    internal struct DeleteSnapshotRequest: Sendable {
      static var loggingCategory: BushelLogging.Category {
        .machine
      }

      private init(snapshot: Snapshot, url: URL) {
        self.snapshot = snapshot
        self.url = url
      }

      let snapshot: Snapshot
      let url: URL

      func isConfirmed(with confirmingRemovingSnapshot: Snapshot?) -> Bool {
        snapshot.id == confirmingRemovingSnapshot?.id
      }

      internal init(snapshot: Snapshot?, url: URL?, using logger: Logger) throws {
        guard let snapshot else {
          let error = MachineError.missingProperty(.snapshot)
          assertionFailure(error: error)
          logger.error("Missing snapshot: \(error)")
          throw error
        }
        guard let url else {
          let error = MachineError.missingProperty(.url)
          assertionFailure(error: error)
          logger.error("Missing url: \(error)")
          throw error
        }
        self.snapshot = snapshot
        self.url = url
      }
    }

    internal struct SnapshotSelection {
      internal init(id: Snapshot.ID, configurationURL: URL, index: Int) {
        self.id = id
        self.configurationURL = configurationURL
        self.index = index
      }

      let id: Snapshot.ID
      let configurationURL: URL
      let index: Int

      static var logger: Logger {
        MachineObject.logger
      }

      init?(selectedSnapshot: UUID?, configurationURL: URL?, snapshots: [Snapshot]) {
        guard let id = selectedSnapshot else {
          Self.logger.error("No snapshot selected.")
          return nil
        }

        guard let configurationURL else {
          assertionFailure("Missing configuration url")
          Self.logger.error("Missing configuration url for SnapshotObject")
          return nil
        }

        guard let index = snapshots.firstIndex(where: { $0.id == id }) else {
          Self.logger.error("Unable to find child image with id: \(id)")
          assertionFailure("Unable to find child image with id: \(id)")
          return nil
        }

        self.init(id: id, configurationURL: configurationURL, index: index)
      }
    }

    func beginSavingSnapshot(_ object: SnapshotObject) {
      Self.logger.debug("Begin saving snapshot")
      Task {
        do {
          try await self.saveSnapshotObject(object)
        } catch let error as SwiftDataError {
          assertionFailure("Unable to save snapshot \(object.initialSnapshot.id): \(error)")
          Self.logger.error("Unable to save snapshot \(object.initialSnapshot.id): \(error)")
          self.error = .fromDatabaseError(error)
        } catch let error as CocoaError {
          assertionFailure("Unable to save snapshot \(object.initialSnapshot.id): \(error)")
          Self.logger.error("Unable to save snapshot \(object.initialSnapshot.id): \(error)")
          Self.logger.error("Unable to save snapshot \(object.initialSnapshot.id): \(error)")
          self.error = .accessDeniedError(error, at: object.machineConfigurationURL)
        } catch let error as DecodingError {
          assertionFailure("Unable to save snapshot \(object.initialSnapshot.id): \(error)")
          Self.logger.error("Unable to save snapshot \(object.initialSnapshot.id): \(error)")
          Self.logger.error("Unable to save snapshot \(object.initialSnapshot.id): \(error)")
          self.error = .corruptedError(error, at: object.machineConfigurationURL)
        } catch {
          assertionFailure(
            "Unable to save snapshot \(object.initialSnapshot.id) with unknown error: \(error)"
          )
          Self.logger.critical(
            "Unable to save snapshot \(object.initialSnapshot.id) with unknown error: \(error)"
          )
        }
      }
    }

    func saveSnapshotObject(_ object: SnapshotObject) async throws {
      Self.logger.debug("Saving snapshot")
      self.updatingSnapshotMetadata = true
      defer {
        self.updatingSnapshotMetadata = false
      }
      await self.machine.updatedMetadata(
        forSnapshot: object.updatedSnapshot,
        atIndex: object.index
      )

      try await SnapshotEntry.synchronizeSnapshotModel(
        object.model,
        with: object.updatedSnapshot,
        machineModel: self.model,
        using: database
      )

      try await writeConfigurationAt(object.machineConfigurationURL)
      await self.refreshSnapshots()
      self.machine = machine

      Self.logger.debug("Saving snapshot completed")
    }

    private func snapshotModelBasedOn(
      selection: MachineObject.SnapshotSelection,
      id: Snapshot.ID
    ) async -> ModelID<SnapshotEntry>? {
      do {
        return try await database.first(#Predicate { $0.snapshotID == id })
      } catch {
        Self.logger.error("Error fetching entry \(selection.id) from database: \(error)")
        assertionFailure(error: error)
        return nil
      }
    }

    func bindableSnapshot(
      usingLabelFrom labelProvider: MetadataLabelProvider,
      fromConfigurationURL configurationURL: URL?
    ) async -> Bindable<SnapshotObject>? {
      guard let selection = await SnapshotSelection(
        selectedSnapshot: selectedSnapshot,
        configurationURL: configurationURL,
        snapshots: machine.updatedConfiguration.snapshots
      ) else {
        return nil
      }
      let id = selection.id
      let model = await snapshotModelBasedOn(selection: selection, id: id)

      guard let model else {
        Self.logger.error("No model with \(selection.id) from database")
        assertionFailure("No model with \(selection.id) from database")
        return nil
      }

      return await .init(
        SnapshotObject(
          fromSnapshots: self.machine.updatedConfiguration.snapshots,
          atIndex: selection.index,
          machineConfigurationURL: selection.configurationURL,
          model: model,
          vmSystemID: machine.updatedConfiguration.vmSystemID,
          using: labelProvider
        )
      )
    }

    func saveSnapshot(
      _ request: SnapshotRequest,
      options: SnapshotOptions,
      at url: URL
    ) async throws {
      assert(self.parent?.allowedToSaveSnapshot == true)
      guard self.parent?.allowedToSaveSnapshot == true else {
        Self.logger.error(
          "This should not be called when the user does not have permission to create another snapshot."
        )
        return
      }

      let snapshot: Snapshot
      snapshot = try await machine.createNewSnapshot(
        request: request,
        options: options,
        using: self.snapshotFactory
      )
      let model: ModelID = await database.insert {
        SnapshotEntry(snapshot)
      }

      let machineModel = self.model
      try await database.fetch {
        FetchDescriptor(model: model)
      } _: {
        FetchDescriptor(model: machineModel)
      } with: { snapshotEntries, machineEntries in
        guard let snapshotEntry = snapshotEntries.first, let machineEntry = machineEntries.first else {
          assertionFailure("synconized ids not found for \(snapshot.id)")
          Self.logger.error("synconized ids not found for \(snapshot.id)")
          return
        }
        snapshotEntry.machine = machineEntry
      }

      try await writeConfigurationAt(url)
      await self.refreshSnapshots()
      self.machine = machine
    }

    nonisolated func queueRestoringSnapshot(_ snapshot: Snapshot) {
      Task { @MainActor in
        confirmingRestoreSnapshot = snapshot
        presentRestoreConfirmation = true
      }
    }

    nonisolated func queueDeletingSnapshot(_ snapshot: Snapshot) {
      Task { @MainActor in
        confirmingRemovingSnapshot = snapshot
        presentDeleteConfirmation = true
      }
    }

    nonisolated func queueExportingSnapshot(_ snapshot: Snapshot) {
      Task { @MainActor in
        self.exportingSnapshot = await (
          snapshot,
          CodablePackageDocument(configuration: self.machine.updatedConfiguration)
        )
        self.presentExportingSnapshot = true
      }
    }

    nonisolated func deleteSnapshot(_ snapshot: Snapshot?, at url: URL?) {
      Task {
        await self.deletingSnapshot(snapshot, at: url)
      }
    }

    func deletingSnapshot(_ snapshot: Snapshot?, at url: URL?) async {
      do {
        let deletingSnapshotRequest = try DeleteSnapshotRequest(
          snapshot: snapshot ?? confirmingRemovingSnapshot,
          url: url,
          using: Self.logger
        )
        assert(deletingSnapshotRequest.isConfirmed(with: confirmingRemovingSnapshot))
        if self.selectedSnapshot == deletingSnapshotRequest.snapshot.id {
          self.selectedSnapshot = nil
        }
        try await machine.deleteSnapshot(deletingSnapshotRequest.snapshot, using: self.snapshotFactory)
        let snapshotID = deletingSnapshotRequest.snapshot.id
        try await database.delete(model: SnapshotEntry.self, where: #Predicate {
          $0.snapshotID == snapshotID
        })
        try await writeConfigurationAt(deletingSnapshotRequest.url)
        Self.logger.debug("Completed deleting snapshot \(snapshotID)")
      } catch {
        let newError: any Error = MachineError.fromSnapshotError(error)
        self.error = assertionFailure(error: newError) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
      }
      await self.refreshSnapshots()
      self.machine = machine
      self.confirmingRemovingSnapshot = nil
    }

    nonisolated func cancelDeleteSnapshot(_ snapshot: Snapshot?) {
      Task { @MainActor in
        assert(snapshot?.id == confirmingRemovingSnapshot?.id)
        self.confirmingRemovingSnapshot = nil
      }
    }

    func synchronizeSnapshots(at url: URL, options: SnapshotSynchronizeOptions) async throws {
      try await self.machine.synchronizeSnapshots(using: self.snapshotFactory, options: options)
      let accessed = url.startAccessingSecurityScopedResource()
      try await self.writeConfigurationAt(url)

      self.model = try await MachineEntry.synchronizeModel(
        self.model,
        with: self.machine,
        osInstalled: nil,
        using: database
      )

      await self.refreshSnapshots()
      self.machine = machine

      Self.logger.notice("Synchronization Complete.")
    }

    func beginSavingSnapshot(_ request: SnapshotRequest, options: SnapshotOptions, at url: URL) {
      currentOperation = .savingSnapshot(request)
      Task {
        defer {
          currentOperation = nil
        }
        do {
          try await self.saveSnapshot(request, options: options, at: url)
        } catch {
          Self.logger.error(
            "Could not create snapshot at \(url, privacy: .public): \(error, privacy: .public)"
          )

          self.error = assertionFailure(error: error) { error in
            Self.logger.critical("Unknown error: \(error)")
          }
        }
      }
    }

    nonisolated func beginRestoreSnapshot(
      _ snapshot: Snapshot,
      at url: URL,
      takeCurrentSnapshot request: SnapshotRequest?
    ) {
      Task { @MainActor in
        assert(snapshot.id == confirmingRestoreSnapshot?.id)
        currentOperation = .restoringSnapshot(snapshot)
        defer {
          currentOperation = nil
        }
        do {
          if let request {
            try await self.saveSnapshot(request, options: [], at: url)
          }
          try await self.machine.restoreSnapshot(snapshot, using: self.snapshotFactory)
          try await MachineEntry.synchronizeModel(
            self.model,
            with: machine,
            osInstalled: nil,
            using: self.database
          )
        } catch {
          Self.logger.error(
            // swiftlint:disable:next line_length
            "Could not restore snapshot \(snapshot.id) to \(url, privacy: .public): \(error, privacy: .public)"
          )
          let newError: any Error = MachineError.fromSnapshotError(error)
          self.error = assertionFailure(error: newError) { error in
            Self.logger.critical("Unknown error: \(error)")
          }
        }
      }
    }

    func beginExport(to result: Result<URL, any Error>) {
      let url: URL
      guard let exportingSnapshot = self.exportingSnapshot else {
        Self.logger.error("Missing snapshot for export")
        assertionFailure("Missing snapshot for export")
        return
      }
      let snapshot = exportingSnapshot.0
      do {
        url = try result.get()
      } catch {
        Self.logger.error("Could not begin export snapshot: \(error, privacy: .public)")

        self.error = assertionFailure(error: error) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
        return
      }
      currentOperation = .exportingSnapshot(snapshot)
      Task {
        defer {
          currentOperation = nil
        }
        await self.exportSnapshot(snapshot, to: url)
      }
    }

    func exportSnapshot(_ snapshot: Snapshot, to url: URL) async {
      do {
        try await self.machine.exportSnapshot(snapshot, to: url, using: self.snapshotFactory)
        let bookmarkDataID = try await BookmarkData.withDatabase(database, fromURL: url) {
          $0.bookmarkID
        }
        let updatedConfiguration = await machine.updatedConfiguration
        let machine = self.machine
        _ = await database.insert {
          MachineEntry(
            bookmarkDataID: bookmarkDataID,
            machine: machine,
            updatedConfiguration: updatedConfiguration,
            osInstalled: nil,
            restoreImageID: updatedConfiguration.restoreImageFile.imageID,
            name: url.deletingPathExtension().lastPathComponent,
            createdAt: .init(),
            lastOpenedAt: .init()
          )
        }
      } catch {
        let machineError = MachineError.fromExportSnapshotError(error)
        assertionFailure(error: machineError)
        self.error = machineError
      }
    }

    nonisolated func cancelRestoreSnapshot(_ snapshot: Snapshot) {
      Task { @MainActor in
        assert(snapshot.id == confirmingRestoreSnapshot?.id)
        self.confirmingRestoreSnapshot = nil
      }
    }

    func refreshSnapshots() async {
      Self.logger.debug("Refreshing Snapshots")
      let snapshots = await self.machine.updatedConfiguration.snapshots
      self.snapshotIDs = snapshots.map(\.id)
      self.latestSnapshots = snapshots
    }
  }
#endif
