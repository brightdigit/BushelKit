//
// FileVersionSnapshotterFactory.swift
// Copyright (c) 2023 BrightDigit.
//

#if !os(Linux)
  import BushelCore
  import Foundation

  public struct FileVersionSnapshotterFactory: SnapshotterFactory {
    public init() {}
    public static var systemID: SnapshotterID {
      "fileVersion"
    }

    public func createNewSnapshot(of machine: some Machine, request: SnapshotRequest, options: SnapshotOptions) async throws -> Snapshot {
      guard let snapshotter = self.snapshotter(supports: type(of: machine).self) else {
        assertionFailure()
        fatalError("Not implmented error")
      }

      return try await snapshotter.createNewSnapshot(of: machine, request: request, options: options)
    }

    public func snapshotter<MachineType>(supports: MachineType.Type) -> (any Snapshotter<MachineType>)? where MachineType: Machine {
      FileVersionSnapshotter(for: supports)
    }
  }
#endif
