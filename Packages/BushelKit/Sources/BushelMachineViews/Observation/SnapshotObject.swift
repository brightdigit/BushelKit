//
// SnapshotObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelMachine
  import BushelMachineData
  import SwiftUI

  @Observable
  class SnapshotObject {
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
  }

  extension SnapshotObject {
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
      self.init(entry: entry, index: index, machineConfigurationURL: machineConfigurationURL, initialSnapshot: snapshot, label: label)
    }

    var isDiscardable: Bool {
      initialSnapshot.isDiscardable
    }

    var createdAt: Date {
      self.initialSnapshot.createdAt
    }

    var fileLength: Int {
      self.initialSnapshot.fileLength
    }

    var hasChanges: Bool {
      self.initialSnapshot.name != self.name || self.initialSnapshot.notes != self.notes
    }
  }
#endif
