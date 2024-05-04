//
// SnapshotRestoreActionsAgent.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine
import Foundation

protocol SnapshotRestoreActionsAgent {
  func cancelRestoreSnapshot(_ snapshot: Snapshot)
  func beginRestoreSnapshot(
    _ snapshot: Snapshot,
    at url: URL,
    takeCurrentSnapshot request: SnapshotRequest?
  )
}

#if canImport(SwiftUI)
  extension MachineObject: SnapshotRestoreActionsAgent {}
#endif
