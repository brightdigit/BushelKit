//
// MachineEntry+Convenience.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelDataCore
  import BushelLogging
  import BushelMachine
  import Foundation
  import SwiftData

  public extension MachineEntry {
    convenience init(
      url: URL,
      machine: any Machine,
      osInstalled: (any OperatingSystemInstalled)?,
      restoreImageID: UUID,
      name: String,
      createdAt: Date,
      lastOpenedAt: Date?,
      withDatabase database: any Database
    ) async throws {
      let bookmark = try await BookmarkData.resolveURL(url, with: database)
      try await self.init(
        bookmarkData: bookmark,
        machine: machine,
        osInstalled: osInstalled,
        restoreImageID: restoreImageID,
        name: name,
        createdAt: createdAt,
        lastOpenedAt: lastOpenedAt,
        withDatabase: database
      )
    }

    convenience init(
      bookmarkData: BookmarkData,
      machine: any Machine,
      osInstalled: (any OperatingSystemInstalled)?,
      restoreImageID: UUID,
      name: String,
      createdAt: Date,
      lastOpenedAt: Date?,
      withDatabase database: any Database
    ) async throws {
      self.init(
        bookmarkData: bookmarkData,
        machine: machine,
        osInstalled: osInstalled,
        restoreImageID: restoreImageID,
        name: name,
        createdAt: createdAt,
        lastOpenedAt: lastOpenedAt
      )
      await database.insert(self)
      try await database.save()
      for snapshot in machine.configuration.snapshots {
        _ = try await SnapshotEntry(
          snapshot,
          machine: self,
          database: database,
          withOS: osInstalled
        )
      }
      try await database.save()
    }

    func synchronizeWith(
      _ machine: any Machine,
      osInstalled: (any OperatingSystemInstalled)?,
      using database: any Database
    ) async throws {
      let entryMap: [UUID: SnapshotEntry] = .init(uniqueKeysWithValues: snapshots?.map {
        ($0.snapshotID, $0)
      } ?? [])

      let imageMap: [UUID: Snapshot] = .init(uniqueKeysWithValues: machine.configuration.snapshots.map {
        ($0.id, $0)
      })

      let entryIDsToUpdate = Set(entryMap.keys).intersection(imageMap.keys)
      let entryIDsToDelete = Set(entryMap.keys).subtracting(imageMap.keys)
      let libraryIDsToInsert = Set(imageMap.keys).subtracting(entryMap.keys)

      let entriesToDelete = entryIDsToDelete.compactMap { entryMap[$0] }
      let libraryItemsToInsert = libraryIDsToInsert.compactMap { imageMap[$0] }

      for entryID in entryIDsToUpdate {
        guard let entry = entryMap[entryID], let image = imageMap[entryID] else {
          assertionFailure("synconized ids not found for \(entryID)")
          Self.logger.error("synconized ids not found for \(entryID)")
          return
        }
        try await entry.syncronizeSnapshot(
          image,
          machine: self,
          database: database,
          withOS: osInstalled
        )
      }

      for snapshot in libraryItemsToInsert {
        _ = try await SnapshotEntry(
          snapshot,
          machine: self,
          database: database,
          withOS: osInstalled
        )
      }

      for snapshot in entriesToDelete {
        await database.delete(snapshot)
      }

      try await database.save()
    }
  }

#endif
