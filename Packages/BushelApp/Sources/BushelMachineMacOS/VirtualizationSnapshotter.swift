//
// VirtualizationSnapshotter.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelMachine
import Foundation

#if canImport(Virtualization) && arch(arm64)

  internal struct VirtualizationSnapshotter: Snapshotter {
    typealias MachineType = VirtualizationMachine

    static let vmSystemID: SnapshotterID = "macOSApple"

    // swiftlint:disable:next unavailable_function
    func exportSnapshot(_: BushelMachine.Snapshot, from _: VirtualizationMachine, to _: URL) async throws {
      fatalError("Not Implmented")
    }

    func deleteSnapshot(_ snapshot: Snapshot, from machine: VirtualizationMachine) throws {
      let paths = try machine.beginSnapshot()
      let snapshotFileURL = paths.snapshotCollectionURL
        .appendingPathComponent(snapshot.id.uuidString)
        .appendingPathExtension("bshsnapshot")
      try FileManager.default.removeItem(at: snapshotFileURL)
      machine.finishedWithSnapshot(snapshot, by: .remove)
    }

    func restoreSnapshot(_ snapshot: Snapshot, to machine: VirtualizationMachine) async throws {
      let paths = try machine.beginSnapshot()
      let snapshotFileURL = paths.snapshotCollectionURL
        .appendingPathComponent(snapshot.id.uuidString)
        .appendingPathExtension("bshsnapshot")
      try await machine.machine.restoreMachineStateFrom(url: snapshotFileURL)
      machine.finishedWithSnapshot(snapshot, by: .restored)
    }

    @MainActor
    func createNewSnapshot(
      of machine: MachineType,
      request: SnapshotRequest,
      options _: SnapshotOptions
    ) async throws -> Snapshot {
      let paths = try machine.beginSnapshot()
      let previousAction = try await machine.prepareForSnapshot()
      let id = UUID()

      try FileManager.default.createEmptyDirectory(
        at: paths.snapshotCollectionURL,
        withIntermediateDirectories: false,
        deleteExistingFile: true
      )

      let snapshotFileURL = paths.snapshotCollectionURL
        .appendingPathComponent(id.uuidString)
        .appendingPathExtension("bshsnapshot")

      try await machine.machine.saveMachineStateTo(url: snapshotFileURL)
      let attrs = try FileManager.default.attributesOfItem(atPath: snapshotFileURL.path)
      let contentLength = attrs[.size] as? Int
      assert(contentLength != nil)

      let snapshot = Snapshot(
        name: request.name,
        id: id,
        snapshotterID: Self.vmSystemID,
        createdAt: .init(),
        isDiscardable: false,
        notes: request.notes
      )
      machine.finishedWithSnapshot(snapshot, by: .append)
      try await machine.resumeFromPreviousAction(previousAction)

      return snapshot
    }
  }
#endif
