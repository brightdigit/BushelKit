//
// SnapshotObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelMachine
  import BushelMachineData
  import SwiftUI

  @Observable
  final class SnapshotObject: Sendable {
    let initialSnapshot: Snapshot
    let entry: SnapshotEntry
    let index: Int
    let machineConfigurationURL: URL
    let label: MetadataLabel?

    var name: String
    var notes: String

    var updatedSnapshot: Snapshot {
      initialSnapshot.updatingWith(name: name, notes: notes)
    }

    init(
      entry: SnapshotEntry,
      index: Int,
      machineConfigurationURL: URL,
      initialSnapshot: Snapshot,
      label: MetadataLabel?,
      name: String? = nil,
      notes: String? = nil
    ) {
      self.entry = entry
      self.index = index
      self.machineConfigurationURL = machineConfigurationURL
      self.label = label
      self.initialSnapshot = initialSnapshot
      self.name = name ?? initialSnapshot.name
      self.notes = notes ?? initialSnapshot.notes
    }
  }

  extension SnapshotObject {
    var isDiscardable: Bool {
      initialSnapshot.isDiscardable
    }

    var createdAt: Date {
      self.initialSnapshot.createdAt
    }

    var hasChanges: Bool {
      self.initialSnapshot.name != self.name || self.initialSnapshot.notes != self.notes
    }

    convenience init(
      fromSnapshots snapshots: [Snapshot],
      atIndex index: Int,
      machineConfigurationURL: URL,
      entry: SnapshotEntry,
      vmSystemID: VMSystemID,
      using labelProvider: MetadataLabelProvider
    ) {
      let snapshot = snapshots[index]
      let label = snapshot.operatingSystemInstalled.map {
        labelProvider(vmSystemID, $0)
      }
      self.init(
        entry: entry,
        index: index,
        machineConfigurationURL: machineConfigurationURL,
        initialSnapshot: snapshot,
        label: label
      )
    }
  }
#endif
