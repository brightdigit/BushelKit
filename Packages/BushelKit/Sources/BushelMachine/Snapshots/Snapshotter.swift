//
// Snapshotter.swift
// Copyright (c) 2023 BrightDigit.
//

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
}
