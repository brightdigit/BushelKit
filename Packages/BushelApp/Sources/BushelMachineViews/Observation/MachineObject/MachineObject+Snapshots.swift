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
  import Foundation
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
      self.machine.updatedMetadata(
        forSnapshot: object.updatedSnapshot,
        atIndex: object.index
      )
      try await object.entry.syncronizeSnapshot(
        object.updatedSnapshot,
        machine: self.entry,
        database: database
      )

      try writeConfigurationAt(object.machineConfigurationURL)
      self.refreshSnapshots()
      self.machine = machine

      Self.logger.debug("Saving snapshot completed")
    }

    private func snapshotEntryBasedOn(
      selection: MachineObject.SnapshotSelection,
      id: Snapshot.ID
    ) async -> SnapshotEntry? {
      if let entryChild = self.entry.snapshots?.first(
        where: { $0.snapshotID == selection.id }
      ) {
        return entryChild
      }

      do {
        return try await database.fetch {
          FetchDescriptor(predicate: #Predicate { $0.snapshotID == id })
        }.first
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
      guard let selection = SnapshotSelection(
        selectedSnapshot: selectedSnapshot,
        configurationURL: configurationURL,
        snapshots: machine.configuration.snapshots
      ) else {
        return nil
      }
      let id = selection.id
      let entry = await snapshotEntryBasedOn(selection: selection, id: id)
      guard let entry else {
        Self.logger.error("No entry with \(selection.id) from database")
        assertionFailure("No entry with \(selection.id) from database")
        return nil
      }

      return .init(
        SnapshotObject(
          fromSnapshots: self.machine.configuration.snapshots,
          atIndex: selection.index,
          machineConfigurationURL: selection.configurationURL,
          entry: entry,
          vmSystemID: machine.configuration.vmSystemID,
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
      _ = try await SnapshotEntry(
        snapshot,
        machine: self.entry,
        database: database
      )

      try writeConfigurationAt(url)
      self.refreshSnapshots()
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
        self.exportingSnapshot = (
          snapshot,
          CodablePackageDocument(configuration: self.machine.configuration)
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
        try machine.deleteSnapshot(deletingSnapshotRequest.snapshot, using: self.snapshotFactory)
        let snapshotID = deletingSnapshotRequest.snapshot.id
        try await database.delete(model: SnapshotEntry.self, where: #Predicate {
          $0.snapshotID == snapshotID
        })
        try writeConfigurationAt(deletingSnapshotRequest.url)
        Self.logger.debug("Completed deleting snapshot \(snapshotID)")
      } catch {
        let newError: any Error = MachineError.fromSnapshotError(error)
        self.error = assertionFailure(error: newError) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
      }
      self.refreshSnapshots()
      self.machine = machine
      self.confirmingRemovingSnapshot = nil
    }

    nonisolated func cancelDeleteSnapshot(_ snapshot: Snapshot?) {
      Task { @MainActor in
        assert(snapshot?.id == confirmingRemovingSnapshot?.id)
        self.confirmingRemovingSnapshot = nil
      }
    }

    func syncronizeSnapshots(at url: URL, options: SnapshotSyncronizeOptions) async throws {
      try await self.machine.syncronizeSnapshots(using: self.snapshotFactory, options: options)
      try self.writeConfigurationAt(url)
      try await self.entry.synchronizeWith(self.machine, osInstalled: nil, using: database)

      self.refreshSnapshots()
      self.machine = machine

      Self.logger.notice("Syncronization Complete.")
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
          try await self.entry.synchronizeWith(machine, osInstalled: nil, using: self.database)
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

        _ = try await MachineEntry(
          url: url,
          machine: machine,
          osInstalled: nil,
          restoreImageID: machine.configuration.restoreImageFile.imageID,
          name: url.deletingPathExtension().lastPathComponent,
          createdAt: .init(),
          lastOpenedAt: .init(),
          withDatabase: database
        )
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

    func refreshSnapshots() {
      Self.logger.debug("Refreshing Snapshots")
      self.snapshotIDs = self.machine.configuration.snapshots.map(\.id)
    }
  }
#endif
