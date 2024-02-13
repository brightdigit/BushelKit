//
// Snapshotter.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public protocol Snapshotter<MachineType> {
  associatedtype MachineType: Machine

  func createNewSnapshot(
    of machine: MachineType,
    request: SnapshotRequest,
    options: SnapshotOptions
  ) async throws -> Snapshot
  func deleteSnapshot(_ snapshot: Snapshot, from machine: MachineType) throws
  func restoreSnapshot(_ snapshot: Snapshot, to machine: MachineType) async throws
  func exportSnapshot(_ snapshot: Snapshot, from machine: MachineType, to url: URL) async throws
  func syncronizeSnapshots(
    for machine: MachineType,
    options: SnapshotSyncronizeOptions
  ) async throws -> SnapshotSyncronizationDifference?
}

public extension Snapshotter {
  func syncronizeSnapshots(
    for _: MachineType,
    options _: SnapshotSyncronizeOptions
  ) async throws -> SnapshotSyncronizationDifference? {
    nil
  }
}
