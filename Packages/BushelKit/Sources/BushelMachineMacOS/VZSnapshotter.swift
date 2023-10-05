//
// VZSnapshotter.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelMachine
import Foundation

#if canImport(Virtualization) && arch(arm64)
  struct VZSnapshotter: Snapshotter {
    func exportSnapshot(_: BushelMachine.Snapshot, from _: VZMachine, to _: URL) async throws {
      throw NSError()
    }

    static let vmSystemID: SnapshotterID = "macOSApple"

    typealias MachineType = VZMachine

    enum PreviousAction {
      case pause
      case start
    }

    func deleteSnapshot(_ snapshot: Snapshot, from machine: VZMachine) throws {
      let paths = machine.beginSnapshot()
      let snapshotFileURL = paths.snapshotCollectionURL.appendingPathComponent(snapshot.id.uuidString).appendingPathExtension("bshsnapshot")
      try FileManager.default.removeItem(at: snapshotFileURL)
      machine.finishedWithSnapshot(snapshot, by: .remove)
    }

    func restoreSnapshot(_ snapshot: Snapshot, to machine: VZMachine) async throws {
      let paths = machine.beginSnapshot()
      let snapshotFileURL = paths.snapshotCollectionURL.appendingPathComponent(snapshot.id.uuidString).appendingPathExtension("bshsnapshot")
      try await machine.machine.restoreMachineStateFrom(url: snapshotFileURL)
      machine.finishedWithSnapshot(snapshot, by: .restored)
    }

    @MainActor
    func createNewSnapshot(of machine: MachineType, request: SnapshotRequest, options _: SnapshotOptions) async throws -> Snapshot {
      let paths = machine.beginSnapshot()
      var action: PreviousAction?
      if machine.canPause {
        try await machine.pause()
        action = .pause
      } else if machine.canStart {
        try await machine.start()
        try await machine.pause()
        action = .start
      }
      let id = UUID()

      try FileManager.default.createEmptyDirectory(at: paths.snapshotCollectionURL, withIntermediateDirectories: false, deleteExistingFile: true)

      let snapshotFileURL = paths.snapshotCollectionURL.appendingPathComponent(id.uuidString).appendingPathExtension("bshsnapshot")

      try await machine.machine.saveMachineStateTo(url: snapshotFileURL)
      let attrs = try FileManager.default.attributesOfItem(atPath: snapshotFileURL.path)
      let contentLength = attrs[.size] as? Int
      assert(contentLength != nil)

      let snapshot = Snapshot(name: request.name, id: id, snapshotterID: Self.vmSystemID, createdAt: .init(), fileLength: contentLength ?? -1, notes: request.notes)
      machine.finishedWithSnapshot(snapshot, by: .append)

      switch action {
      case .pause:
        try await machine.resume()

      case .start:
        try await machine.stop()

      default:
        break
      }
      return snapshot
    }
  }
#endif
