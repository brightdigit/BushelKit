//
// FileVersionSnapshotter+Syncronization.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  import BushelCore
  import BushelLogging
  import Foundation

  extension FileVersionSnapshotter {
    private func updateSnapshots(atPaths paths: SnapshotPaths) throws -> [Snapshot]? {
      let versions = NSFileVersion.otherVersionsOfItem(at: paths.snapshottingSourceURL)
      assert(versions != nil)
      guard let versions else {
        return nil
      }

      let updates = try self.fileManager.fileUpdates(
        atDirectoryURL: paths.snapshotCollectionURL,
        fromVersions: versions,
        logger: Self.logger
      )

      let snapshotsAdded = try self.applyUpdates(updates, to: paths.snapshotCollectionURL)

      Self.logger.notice(
        "Updated stored snapshots: -\(updates.filesToDelete.count) +\(snapshotsAdded.count)"
      )

      return snapshotsAdded
    }

    private func applyUpdates(
      _ updates: SnapshotFileUpdate,
      to snapshotCollectionURL: URL
    ) throws -> [Snapshot] {
      try updates.filesToDelete.forEach { url in
        try fileManager.removeItem(at: url)
      }

      return try updates.versionsToAdd.map { versionToAdd in
        try self.saveSnapshot(forVersion: versionToAdd, to: snapshotCollectionURL)
      }
    }

    func syncronizeSnapshots(
      for machine: MachineType,
      options _: SnapshotSyncronizeOptions
    ) async throws -> SnapshotSyncronizationDifference? {
      let paths = try machine.beginSnapshot()

      guard let snapshotsAdded = try self.updateSnapshots(atPaths: paths) else {
        return nil
      }

      let snapshotIDs = try self.fileManager.filenameUUIDs(atDirectoryURL: paths.snapshotCollectionURL)

      return .init(addedSnapshots: snapshotsAdded, snapshotIDs: snapshotIDs)
    }
  }
#endif
