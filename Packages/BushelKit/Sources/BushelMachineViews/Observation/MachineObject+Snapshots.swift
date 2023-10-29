//
// MachineObject+Snapshots.swift
// Copyright (c) 2023 BrightDigit.
//

// swiftlint:disable file_length

#if canImport(SwiftUI)
  import BushelCore
  import BushelMachine
  import BushelMachineData
  import BushelViewsCore
  import Foundation
  import SwiftData
  import SwiftUI

  extension MachineObject {
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
          assertionFailure("Unable to save snapshot \(object.initialSnapshot.id) with unknown error: \(error)")
          Self.logger.critical("Unable to save snapshot \(object.initialSnapshot.id) with unknown error: \(error)")
        }
      }
    }

    func saveSnapshotObject(_ object: SnapshotObject) async throws {
      Self.logger.debug("Saving snapshot")
      self.updatingSnapshotMetadata = true
      defer {
        self.updatingSnapshotMetadata = false
      }
      self.machine.updatedMetadata(forSnapshot: object.updatedSnapshot, atIndex: object.index)
      try await object.entry.syncronizeSnapshot(object.updatedSnapshot, machine: self.entry, using: modelContext)

      try writeConfigurationAt(object.machineConfigurationURL)
      self.refreshSnapshots()
      self.machine = machine

      Self.logger.debug("Saving snapshot completed")
    }

    func bindableSnapshot(
      usingLabelFrom labelProvider: MetadataLabelProvider,
      fromConfigurationURL configurationURL: URL?
    ) -> Bindable<SnapshotObject>? {
      guard let id = selectedSnapshot else {
        return nil
      }

      guard let configurationURL else {
        assertionFailure("Missing configuration url")
        Self.logger.error("Missing configuration url for SnapshotObject")
        return nil
      }

      guard let index = machine.configuration.snapshots.firstIndex(where: { $0.id == id }) else {
        Self.logger.error("Unable to find child image with id: \(id)")
        assertionFailure("Unable to find child image with id: \(id)")
        return nil
      }
      let entryChild = self.entry.snapshots?.first(where: { $0.snapshotID == id })
      let entry: SnapshotEntry?
      do {
        entry = try entryChild ?? modelContext.fetch(
          FetchDescriptor<SnapshotEntry>(
            predicate: #Predicate { $0.snapshotID == id }
          )
        ).first
      } catch {
        Self.logger.error("Error fetching entry \(id) from database: \(error)")
        assertionFailure(error: error)
        return nil
      }
      guard let entry else {
        Self.logger.error("No entry with \(id) from database")
        assertionFailure("No entry with \(id) from database")
        return nil
      }

      return .init(
        SnapshotObject(
          fromSnapshots: self.machine.configuration.snapshots,
          atIndex: index,
          machineConfigurationURL: configurationURL,
          entry: entry,
          vmSystemID: machine.configuration.vmSystemID,
          using: labelProvider
        )
      )
    }

    func saveSnapshot(_ request: SnapshotRequest, options _: SnapshotOptions, at url: URL) async throws {
      let snapshot: Snapshot
      snapshot = try await machine.createNewSnapshot(
        request: request,
        options: .init(),
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
        guard let snapshot = snapshot ?? confirmingRemovingSnapshot else {
          let error = MachineError.missingProperty(.snapshot)
          assertionFailure(error: error)
          Self.logger.error("Missing snapshot: \(error)")
          throw error
        }
        guard let url else {
          let error = MachineError.missingProperty(.url)
          assertionFailure(error: error)
          Self.logger.error("Missing url: \(error)")
          throw error
        }
        if snapshot.id != confirmingRemovingSnapshot?.id {
          let confirmingRemovingSnapshotIDString = self.confirmingRemovingSnapshot?.id.uuidString ?? "null"
          assertionFailure("\(snapshot.id) != \(confirmingRemovingSnapshotIDString)")
          Self.logger.error(
            "Not matching snapshot ids: \(snapshot.id) != \(confirmingRemovingSnapshotIDString)"
          )
        }
        if self.selectedSnapshot == snapshot.id {
          self.selectedSnapshot = nil
        }
        try machine.deleteSnapshot(snapshot, using: self.snapshotFactory)
        let snapshotID = snapshot.id
        try modelContext.delete(model: SnapshotEntry.self, where: #Predicate {
          $0.snapshotID == snapshotID
        })
        try writeConfigurationAt(url)
      } catch {
        self.error = assertionFailure(error: error) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
      }
      #warning("logging-note: should we log here?")
      self.refreshSnapshots()
      self.machine = machine
      self.confirmingRemovingSnapshot = nil
    }

    #warning("logging-note: should we log here?")
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

          self.error = assertionFailure(error: error) { error in
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
        let machineError: MachineError = if let bookmarkError = error as? BookmarkError {
          .bookmarkError(bookmarkError)
        } else {
          .fromDatabaseError(error)
        }
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
