//
// MachineEntry+Convenience.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  public import BushelCore

  public import DataThespian

  import BushelDataCore
  import BushelLogging

  public import BushelMachine

  import Foundation
  import SwiftData

  extension MachineEntry {
    public struct SyncronizationDifference: Sendable {
      public let model: ModelID<MachineEntry>
      public let machineIdentifier: UInt64?
      public let osVersion: OperatingSystemVersionComponents?

      public let snapshotsToInsert: [Snapshot]
      public let snapshotModelsToDelete: [ModelID<SnapshotEntry>]
      public let snapshotsToUpdate: [Snapshot]
    }

    #warning("Refactor Syncronization Technique")
    // swiftlint:disable:next function_body_length
    internal static func syncronize(
      _ diff: SyncronizationDifference,
      using database: any Database
    ) async throws -> ModelID<MachineEntry> {
      // swiftlint:disable:next closure_body_length
      try await withThrowingTaskGroup(of: Void.self) { group in
        // update machine identifier
        group.addTask {
          try await database.with(diff.model) { machineEntry in
            machineEntry.machineIdentifer = diff.machineIdentifier
          }
        }

        // update snapshots
        group.addTask {
          try await withThrowingTaskGroup(of: Void.self) { group in
            for snapshot in diff.snapshotsToUpdate {
              group.addTask {
                try await database.fetch {
                  FetchDescriptor(
                    predicate: #Predicate<SnapshotEntry> { $0.snapshotID == snapshot.id },
                    fetchLimit: 1
                  )
                } _: {
                  FetchDescriptor(
                    model: diff.model
                  )
                } with: { snapshotEntries, machineEntries in
                  guard
                    let snapshotEntry = snapshotEntries.first,
                    let machineEntry = machineEntries.first else {
                    assertionFailure("synconized ids not found for \(snapshot.id)")
                    Self.logger.error("synconized ids not found for \(snapshot.id)")
                    return
                  }

                  try snapshotEntry.syncronizeSnapshot(
                    snapshot,
                    withOS: diff.osVersion
                  )
                  snapshotEntry.machine = machineEntry
                }
              }
            }
            try await group.waitForAll()
          }
        }

        // insert snapshots
        group.addTask {
          try await withThrowingTaskGroup(of: Void.self) { group in
            for snapshot in diff.snapshotsToInsert {
              group.addTask {
                let snapshotModel: ModelID = await database.insert {
                  SnapshotEntry(
                    snapshot,
                    withOS: diff.osVersion
                  )
                }
                try await database.fetch {
                  .init(model: snapshotModel)
                } _: {
                  .init(model: diff.model)
                } with: { snapshotEntries, machineEntries in
                  guard
                    let snapshotEntry = snapshotEntries.first,
                    let machineEntry = machineEntries.first else {
                    assertionFailure("synconized ids not found for \(snapshot.id)")
                    Self.logger.error("synconized ids not found for \(snapshot.id)")
                    return
                  }

                  snapshotEntry.machine = machineEntry
                }
              }
            }

            return try await group.waitForAll()
          }
        }

        // delete snapshots
        group.addTask {
          await withTaskGroup(of: Void.self) { group in
            for snapshot in diff.snapshotModelsToDelete {
              group.addTask {
                await database.delete(snapshot)
              }
            }

            await group.waitForAll()
          }
        }

        try await group.waitForAll()
        return diff.model
      }
    }

    public static func syncronizeModel(
      _ model: ModelID<MachineEntry>,
      with machine: any Machine,
      osInstalled: OperatingSystemVersionComponents?,
      using database: any Database
    ) async throws -> ModelID<MachineEntry> {
      let updatedConfiguration = await machine.updatedConfiguration
      let diff = try await database.with(model) { machineEntry in
        machineEntry.syncronizationReport(
          machine,
          osInstalled: osInstalled,
          withConfiguration: updatedConfiguration
        )
      }

      return try await Self.syncronize(diff, using: database)
    }

    public func syncronizationReport(
      _ machine: any Machine,
      osInstalled: OperatingSystemVersionComponents?,
      withConfiguration configuration: MachineConfiguration
    ) -> SyncronizationDifference {
      let entryMap: [UUID: SnapshotEntry] = .init(uniqueKeysWithValues: snapshots?.map {
        ($0.snapshotID, $0)
      } ?? [])

      let imageMap: [UUID: Snapshot] = .init(uniqueKeysWithValues: configuration.snapshots.map {
        ($0.id, $0)
      })

      let entryIDsToUpdate = Set(entryMap.keys).intersection(imageMap.keys)
      let snapshotIDsToDelete = Set(entryMap.keys).subtracting(imageMap.keys)
      let entryIDsToInsert = Set(imageMap.keys).subtracting(entryMap.keys)

      let snapshotsOptToInsert = entryIDsToInsert.map { imageMap[$0] }
      let snapshotsOptToUpdate = entryIDsToUpdate.map { imageMap[$0] }
      let snapshotEntriesToDelete = snapshotIDsToDelete.map { entryMap[$0] }

      let snapshotsToInsert = snapshotsOptToInsert.compactMap { $0 }
      let snapshotsToUpdate = snapshotsOptToUpdate.compactMap { $0 }
      let snapshotModelsToDelete = snapshotEntriesToDelete.compactMap { $0 }.map(ModelID.init)

      assert(snapshotsOptToInsert.count == snapshotsToInsert.count)
      assert(snapshotsOptToUpdate.count == snapshotsToUpdate.count)
      assert(snapshotEntriesToDelete.count == snapshotModelsToDelete.count)

      return .init(
        model: .init(self),
        machineIdentifier: machine.machineIdentifer,
        osVersion: osInstalled,
        snapshotsToInsert: snapshotsToInsert,
        snapshotModelsToDelete: snapshotModelsToDelete,
        snapshotsToUpdate: snapshotsToUpdate
      )
    }

    public func synchronizeWith(
      _ machine: any Machine,
      osInstalled: OperatingSystemVersionComponents?,
      using database: any Database
    ) async throws -> ModelID<MachineEntry> {
      let model = ModelID(self)
      return try await Self.syncronizeModel(model, with: machine, osInstalled: osInstalled, using: database)
    }
  }

#endif
