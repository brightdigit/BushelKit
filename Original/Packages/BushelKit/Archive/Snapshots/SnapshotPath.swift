//
// SnapshotPath.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelVirtualization
import Foundation

public struct SnapshotPath {
  public let machinePath: String
  public let snapshotID: MachineSnapshot.ID

  public var path: String {
    [machinePath, snapshotID.base64EncodedString()].joined(separator: "/")
  }

  public init(machinePath: String, snapshotID: MachineSnapshot.ID) {
    self.machinePath = machinePath
    self.snapshotID = snapshotID
  }

  public init?(externalURL: URL) throws {
    if externalURL.path.isEmpty {
      return nil
    }
    let base64EncodedID = externalURL.lastPathComponent
    let machinePath = externalURL.deletingLastPathComponent().path

    guard let snapshotID = Data(base64Encoded: base64EncodedID) else {
      throw MachineError.undefinedType("Invalid Snapshot ID", externalURL)
    }
    self.init(machinePath: machinePath, snapshotID: snapshotID)
  }
}
