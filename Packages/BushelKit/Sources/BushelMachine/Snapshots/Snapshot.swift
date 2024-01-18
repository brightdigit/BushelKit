//
// Snapshot.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public struct Snapshot: Codable, Identifiable {
  public var name: String
  public let id: UUID
  public let snapshotterID: SnapshotterID
  public let createdAt: Date
  public var notes: String
  public var operatingSystemVersion: OperatingSystemVersion?
  public var buildVersion: String?
  public var isDiscardable: Bool
  public init(
    name: String,
    id: UUID,
    snapshotterID: SnapshotterID,
    createdAt: Date,
    isDiscardable: Bool,
    notes: String = "",
    operatingSystemVersion: OperatingSystemVersion? = nil,
    buildVersion: String? = nil
  ) {
    self.name = name
    self.id = id
    self.snapshotterID = snapshotterID
    self.createdAt = createdAt
    self.isDiscardable = isDiscardable
    self.notes = notes
    self.operatingSystemVersion = operatingSystemVersion
    self.buildVersion = buildVersion
  }
}

public extension Snapshot {
  internal struct OperatingSystem: OperatingSystemInstalled {
    internal init(operatingSystemVersion: OperatingSystemVersion, buildVersion: String?) {
      self.operatingSystemVersion = operatingSystemVersion
      self.buildVersion = buildVersion
    }

    internal init?(operatingSystemVersion: OperatingSystemVersion?, buildVersion: String?) {
      guard let operatingSystemVersion else {
        return nil
      }
      self.init(operatingSystemVersion: operatingSystemVersion, buildVersion: buildVersion)
    }

    let operatingSystemVersion: OperatingSystemVersion
    let buildVersion: String?
  }

  var operatingSystemInstalled: OperatingSystemInstalled? {
    OperatingSystem(operatingSystemVersion: self.operatingSystemVersion, buildVersion: self.buildVersion)
  }

  func updatingWith(name newName: String, notes newNotes: String) -> Snapshot {
    Snapshot(
      name: newName,
      id: id,
      snapshotterID: snapshotterID,
      createdAt: createdAt,
      isDiscardable: isDiscardable,
      notes: newNotes,
      operatingSystemVersion: operatingSystemVersion,
      buildVersion: buildVersion
    )
  }
}
