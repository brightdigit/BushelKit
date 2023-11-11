//
// VirtualizationSnapshotter.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelMachine
import Foundation

#if canImport(Virtualization) && arch(arm64)

  struct VirtualizationSnapshotter: Snapshotter {
    typealias MachineType = VirtualizationMachine

    static let vmSystemID: SnapshotterID = "macOSApple"

    // swiftlint:disable:next unavailable_function
    func exportSnapshot(_: BushelMachine.Snapshot, from _: VirtualizationMachine, to _: URL) async throws {
      fatalError("Not Implmented")
    }

    func deleteSnapshot(_ snapshot: Snapshot, from machine: VirtualizationMachine) throws {
      let paths = machine.beginSnapshot()
      let snapshotFileURL = paths.snapshotCollectionURL
        .appendingPathComponent(snapshot.id.uuidString)
        .appendingPathExtension("bshsnapshot")
      try FileManager.default.removeItem(at: snapshotFileURL)
      machine.finishedWithSnapshot(snapshot, by: .remove)
    }

    func restoreSnapshot(_ snapshot: Snapshot, to machine: VirtualizationMachine) async throws {
      let paths = machine.beginSnapshot()
      let snapshotFileURL = paths.snapshotCollectionURL
        .appendingPathComponent(snapshot.id.uuidString)
        .appendingPathExtension("bshsnapshot")
      try await machine.machine.restoreMachineStateFrom(url: snapshotFileURL)
      machine.finishedWithSnapshot(snapshot, by: .restored)
    }

    #warning("logging-note: I think we should log every step here?")
    @MainActor
    func createNewSnapshot(
      of machine: MachineType,
      request: SnapshotRequest,
      options _: SnapshotOptions
    ) async throws -> Snapshot {
      let paths = machine.beginSnapshot()
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
        fileLength: contentLength ?? -1,
        isDiscardable: false,
        notes: request.notes
      )
      machine.finishedWithSnapshot(snapshot, by: .append)
      try await machine.resumeFromPreviousAction(previousAction)

      return snapshot
    }
  }
#endif
