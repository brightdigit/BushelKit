//
// SnapshotSyncronizationDifference.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public struct SnapshotSyncronizationDifference {
  public let addedSnapshots: [Snapshot]
  public let snapshotIDs: [UUID]
}
