//
// FileVersionSnapshotterFactory.swift
// Copyright (c) 2024 BrightDigit.
//

#if os(macOS)
  import BushelCore
  import Foundation

  public struct FileVersionSnapshotterFactory: SnapshotterFactory {
    public static var systemID: SnapshotterID {
      "fileVersion"
    }

    public init() {}

    public func createNewSnapshot(
      of machine: some Machine,
      request: SnapshotRequest,
      options: SnapshotOptions
    ) async throws -> Snapshot {
      guard let snapshotter = self.snapshotter(supports: type(of: machine).self) else {
        assertionFailure()
        fatalError("Not implmented error")
      }

      return try await snapshotter.createNewSnapshot(of: machine, request: request, options: options)
    }

    public func snapshotter<MachineType>(
      supports: MachineType.Type
    ) -> (any Snapshotter<MachineType>)? where MachineType: Machine {
      FileVersionSnapshotter(for: supports)
    }
  }
#endif
