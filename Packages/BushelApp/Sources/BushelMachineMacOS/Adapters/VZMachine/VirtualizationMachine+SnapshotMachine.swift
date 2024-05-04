//
// VirtualizationMachine+SnapshotMachine.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelMachine
import Foundation

#if canImport(Virtualization) && arch(arm64)

  extension VirtualizationMachine {
    func beginSnapshot() throws -> SnapshotPaths {
      guard url.startAccessingSecurityScopedResource() else {
        throw MachineError.accessDeniedError(nil, at: url)
      }
      return .init(machinePathURL: url)
    }

    func updatedMetadata(forSnapshot snapshot: Snapshot, atIndex index: Int) {
      self.configuration.snapshots[index] = snapshot
    }

    func finishedWithSyncronization(_ difference: SnapshotSyncronizationDifference?) throws {
      if let difference {
        let indicies = self.configuration.snapshots.enumerated().compactMap { index, snapshot in
          difference.snapshotIDs.contains(snapshot.id) ? nil : index
        }
        let indexSet = IndexSet(indicies)
        self.configuration.snapshots.remove(atOffsets: indexSet)
        self.configuration.snapshots.append(contentsOf: difference.addedSnapshots)
        self.configuration.snapshots.removeDuplicates(groupingBy: { $0.id })
        self.configuration.snapshots.sort(by: { $0.createdAt < $1.createdAt })
        Self.logger.notice(
          "Updated configured snapshots: -\(indicies.count) +\(difference.addedSnapshots.count)"
        )
      }
      url.stopAccessingSecurityScopedResource()
    }

    func finishedWithSnapshot(_ snapshot: BushelMachine.Snapshot, by difference: SnapshotDifference) {
      Self.logger.debug("Finished with Snapshot operation \(difference.rawValue).")
      url.stopAccessingSecurityScopedResource()
      switch difference {
      case .append:
        self.configuration.snapshots.append(snapshot)

      case .remove:
        let index = self.configuration.snapshots.firstIndex { $0.id == snapshot.id }
        guard let index else {
          Self.logger.error("Unable to find snapshot with id: \(snapshot.id)")
          assertionFailure("Unable to find snapshot with id: \(snapshot.id)")
          return
        }
        self.configuration.snapshots.remove(at: index)

      case .restored:
        break

      case .export:
        break
      }
    }
  }
#endif
