//
// MachineEntry+Convenience.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelDataCore
  import BushelLogging
  import BushelMachine
  import Foundation
  import SwiftData

  public extension MachineEntry {
    @MainActor
    convenience init(
      url: URL,
      machine: any Machine,
      osInstalled: OperatingSystemInstalled?,
      restoreImageID: UUID,
      name: String,
      createdAt: Date,
      lastOpenedAt: Date?,
      withContext context: ModelContext
    ) throws {
      let bookmark = try BookmarkData.resolveURL(url, with: context)
      try self.init(
        bookmarkData: bookmark,
        machine: machine,
        osInstalled: osInstalled,
        restoreImageID: restoreImageID,
        name: name,
        createdAt: createdAt,
        lastOpenedAt: lastOpenedAt,
        withContext: context
      )
    }

    @MainActor
    convenience init(
      bookmarkData: BookmarkData,
      machine: any Machine,
      osInstalled: OperatingSystemInstalled?,
      restoreImageID: UUID,
      name: String,
      createdAt: Date,
      lastOpenedAt: Date?,
      withContext context: ModelContext
    ) throws {
      self.init(
        bookmarkData: bookmarkData,
        machine: machine,
        osInstalled: osInstalled,
        restoreImageID: restoreImageID,
        name: name,
        createdAt: createdAt,
        lastOpenedAt: lastOpenedAt
      )
      context.insert(self)
      try context.save()
      try machine.configuration.snapshots.forEach {
        _ = try SnapshotEntry($0, machine: self, osInstalled: osInstalled, using: context)
      }
      try context.save()
    }

    #warning("Remove @MainActor")
    @MainActor
    func synchronizeWith(
      _ machine: any Machine,
      osInstalled: OperatingSystemInstalled?,
      using context: ModelContext
    ) throws {
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

      try entryIDsToUpdate.forEach { entryID in
        guard let entry = entryMap[entryID], let image = imageMap[entryID] else {
          assertionFailure("synconized ids not found for \(entryID)")
          Self.logger.error("synconized ids not found for \(entryID)")
          return
        }
        try entry.syncronizeSnapshot(image, machine: self, osInstalled: osInstalled, using: context)
      }

      try libraryItemsToInsert.forEach {
        _ = try SnapshotEntry(
          $0,
          machine: self,
          osInstalled: osInstalled,
          using: context
        )
      }

      entriesToDelete.forEach(context.delete)
      try context.save()
    }
  }

#endif
