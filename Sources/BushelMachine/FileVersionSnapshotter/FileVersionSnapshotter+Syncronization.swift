//
//  FileVersionSnapshotter+Syncronization.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#if os(macOS)

  import Foundation

  extension FileVersionSnapshotter {
    private func updateSnapshots(atPaths paths: SnapshotPaths) throws -> [Snapshot]? {
      let versions = NSFileVersion.otherVersionsOfItem(at: paths.snapshottingSourceURL)
      assert(versions != nil)
      guard let versions else { return nil }

      let updates = try fileManager.fileUpdates(
        atDirectoryURL: paths.snapshotCollectionURL,
        fromVersions: versions,
        logger: Self.logger
      )

      let snapshotsAdded = try applyUpdates(updates, to: paths.snapshotCollectionURL)

      Self.logger.notice(
        "Updated stored snapshots: -\(updates.filesToDelete.count) +\(snapshotsAdded.count)"
      )

      return snapshotsAdded
    }

    private func applyUpdates(_ updates: SnapshotFileUpdate, to snapshotCollectionURL: URL) throws
      -> [Snapshot]
    {
      for url in updates.filesToDelete {
        try fileManager.removeItem(at: url)
      }

      return try updates.versionsToAdd.map { versionToAdd in
        try self.saveSnapshot(forVersion: versionToAdd, to: snapshotCollectionURL)
      }
    }

    public func synchronizeSnapshots(
      for machine: MachineType,
      options _: SnapshotSynchronizeOptions
    ) async throws -> SnapshotSynchronizationDifference? {
      let paths = try machine.beginSnapshot()

      guard let snapshotsAdded = try updateSnapshots(atPaths: paths) else { return nil }

      let snapshotIDs = try fileManager.filenameUUIDs(atDirectoryURL: paths.snapshotCollectionURL)

      return .init(addedSnapshots: snapshotsAdded, snapshotIDs: snapshotIDs)
    }
  }
#endif
