//
// SnapshotDeleteActionsAgent.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine
import Foundation

internal protocol SnapshotDeleteActionsAgent {
  func cancelDeleteSnapshot(_ snapshot: Snapshot?)
  func deleteSnapshot(_ snapshot: Snapshot?, at url: URL?)
}

#if canImport(SwiftUI)
  extension MachineObject: SnapshotDeleteActionsAgent {}
#endif
