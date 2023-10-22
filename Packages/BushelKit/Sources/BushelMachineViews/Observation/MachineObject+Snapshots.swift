//
// MachineObject+Snapshots.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelMachine
  import BushelMachineData
  import BushelViewsCore
  import Foundation

  extension MachineObject {
    func saveSnapshot(_ request: SnapshotRequest, at url: URL) async throws {
      let snapshot: Snapshot
      snapshot = try await machine.createNewSnapshot(
        request: request,
        options: .init(),
        using: self.snapshotFactory
      )
      _ = try SnapshotEntry(snapshot, machine: self.entry, using: modelContext)

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

    func beginSavingSnapshot(_ request: SnapshotRequest, at url: URL) {
      currentOperation = .savingSnapshot(request)
      Task {
        defer {
          currentOperation = nil
        }
        do {
          try await self.saveSnapshot(request, at: url)
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
            try await self.saveSnapshot(request, at: url)
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

        _ = try MachineEntry(
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
