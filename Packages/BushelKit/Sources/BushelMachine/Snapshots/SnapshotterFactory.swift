//
// SnapshotterFactory.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelLogging

public protocol SnapshotterFactory: Loggable, Sendable {
  static var systemID: SnapshotterID { get }
  func createNewSnapshot(
    of machine: some Machine,
    request: SnapshotRequest,
    options: SnapshotOptions
  ) async throws -> Snapshot
  func snapshotter<MachineType: Machine>(supports: MachineType.Type) -> (any Snapshotter<MachineType>)?
}

extension SnapshotterFactory {
  public static var loggingCategory: BushelLogging.Category {
    .machine
  }

  func createNewSnapshot(
    of machine: some Machine,
    request: SnapshotRequest,
    options: SnapshotOptions
  ) async throws -> Snapshot {
    guard let snapshotter = self.snapshotter(supports: type(of: machine).self) else {
      Self.logger.critical("Unknown system: \(type(of: machine).self)")
      preconditionFailure("Unknown system: \(type(of: machine).self)")
    }

    return try await snapshotter.createNewSnapshot(of: machine, request: request, options: options)
  }
}
