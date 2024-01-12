//
// SnapshotActionsAgent.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine

protocol SnapshotActionsAgent {
  func queueRestoringSnapshot(_ snapshot: Snapshot)
  func queueDeletingSnapshot(_ snapshot: Snapshot)
  func queueExportingSnapshot(_ snapshot: Snapshot)
}

#if canImport(SwiftUI)
  extension MachineObject: SnapshotActionsAgent {}
#endif
