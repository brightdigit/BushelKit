//
// MachineObject+Snapshots.swift
// Copyright (c) 2023 BrightDigit.
//

// swiftlint:disable file_length

#if canImport(SwiftUI)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import BushelMachineData
  import BushelViewsCore
  import Foundation
  import SwiftData
  import SwiftUI

  extension MachineObject {
    struct DeleteSnapshotRequest {
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

    struct SnapshotSelection {
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
        using: modelContext
      )

      try writeConfigurationAt(object.machineConfigurationURL)
      self.refreshSnapshots()
      self.machine = machine

      Self.logger.debug("Saving snapshot completed")
    }

    func bindableSnapshot(
      usingLabelFrom labelProvider: MetadataLabelProvider,
      fromConfigurationURL configurationURL: URL?
    ) -> Bindable<SnapshotObject>? {
      guard let selection = SnapshotSelection(
        selectedSnapshot: selectedSnapshot,
        configurationURL: configurationURL,
        snapshots: machine.configuration.snapshots
      ) else {
        return nil
      }
      let id = selection.id
      let entryChild = self.entry.snapshots?.first(where: { $0.snapshotID == selection.id })
      let entry: SnapshotEntry?
      do {
        entry = try entryChild ?? modelContext.fetch(
          FetchDescriptor<SnapshotEntry>(
            predicate: #Predicate { $0.snapshotID == id }
          )
        ).first
      } catch {
        Self.logger.error("Error fetching entry \(selection.id) from database: \(error)")
        assertionFailure(error: error)
        return nil
      }
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

    func saveSnapshot(_ request: SnapshotRequest, options: SnapshotOptions, at url: URL) async throws {
      let snapshot: Snapshot
      snapshot = try await machine.createNewSnapshot(
        request: request,
        options: options,
        using: self.snapshotFactory
      )
      _ = try await SnapshotEntry(snapshot, machine: self.entry, using: modelContext)

      try writeConfigurationAt(url)
      self.refreshSnapshots()
      self.machine = machine
    }

    func queueRestoringSnapshot(_ snapshot: Snapshot) {
      confirmingRestoreSnapshot = snapshot
      presentRestoreConfirmation = true
    }

    func queueDeletingSnapshot(_ snapshot: Snapshot) {
      confirmingRemovingSnapshot = snapshot
      presentDeleteConfirmation = true
    }

    func queueExportingSnapshot(_ snapshot: Snapshot) {
      self.exportingSnapshot = (
        snapshot,
        CodablePackageDocument(configuration: self.machine.configuration)
      )
      self.presentExportingSnapshot = true
    }

    func deleteSnapshot(_ snapshot: Snapshot?, at url: URL?) {
      do {
        let deletingSnapshotRequest = try DeleteSnapshotRequest(
          snapshot: snapshot ?? confirmingRemovingSnapshot,
          url: url,
          using: Self.logger
        )
        assert(deletingSnapshotRequest.isConfirmed(with: confirmingRestoreSnapshot))
        if self.selectedSnapshot == deletingSnapshotRequest.snapshot.id {
          self.selectedSnapshot = nil
        }
        try machine.deleteSnapshot(deletingSnapshotRequest.snapshot, using: self.snapshotFactory)
        let snapshotID = deletingSnapshotRequest.snapshot.id
        try modelContext.delete(model: SnapshotEntry.self, where: #Predicate {
          $0.snapshotID == snapshotID
        })
        try writeConfigurationAt(deletingSnapshotRequest.url)
        Self.logger.debug("Completed deleting snapshot \(snapshotID)")
      } catch {
        let newError: Error = MachineError.fromSnapshotError(error)
        self.error = assertionFailure(error: newError) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
      }
      self.refreshSnapshots()
      self.machine = machine
      self.confirmingRemovingSnapshot = nil
    }

    func cancelDeleteSnapshot(_ snapshot: Snapshot?) {
      assert(snapshot?.id == confirmingRemovingSnapshot?.id)
      self.confirmingRemovingSnapshot = nil
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

    func beginRestoreSnapshot(
      _ snapshot: Snapshot,
      at url: URL,
      takeCurrentSnapshot request: SnapshotRequest?
    ) {
      assert(snapshot.id == confirmingRestoreSnapshot?.id)
      currentOperation = .restoringSnapshot(snapshot)
      Task {
        defer {
          currentOperation = nil
        }
        do {
          if let request {
            try await self.saveSnapshot(request, options: [], at: url)
          }
          try await self.machine.restoreSnapshot(snapshot, using: self.snapshotFactory)
          try await self.entry.synchronizeWith(machine, osInstalled: nil, using: self.modelContext)
        } catch {
          Self.logger.error(
            // swiftlint:disable:next line_length
            "Could not restore snapshot \(snapshot.id) to \(url, privacy: .public): \(error, privacy: .public)"
          )
          let newError: Error = MachineError.fromSnapshotError(error)
          self.error = assertionFailure(error: newError) { error in
            Self.logger.critical("Unknown error: \(error)")
          }
        }
      }
    }

    func beginExport(to result: Result<URL, Error>) {
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
          withContext: modelContext
        )
      } catch {
        let machineError = MachineError.fromExportSnapshotError(error)
        assertionFailure(error: machineError)
        self.error = machineError
      }
    }

    func cancelRestoreSnapshot(_ snapshot: Snapshot) {
      assert(snapshot.id == confirmingRestoreSnapshot?.id)
      self.confirmingRestoreSnapshot = nil
    }

    func refreshSnapshots() {
      self.snapshotIDs = self.machine.configuration.snapshots.map(\.id)
    }
  }
#endif
