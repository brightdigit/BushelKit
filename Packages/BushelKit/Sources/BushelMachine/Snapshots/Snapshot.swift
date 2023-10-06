//
// Snapshot.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public struct Snapshot: Codable, Identifiable {
  public var name: String
  public let id: UUID
  public let snapshotterID: SnapshotterID
  public let createdAt: Date
  public let fileLength: Int
  public var notes: String
  public var operatingSystemVersion: OperatingSystemVersion?
  public var buildVersion: String?
  public init(
    name: String,
    id: UUID,
    snapshotterID: SnapshotterID,
    createdAt: Date,
    fileLength: Int,
    notes: String = "",
    operatingSystemVersion: OperatingSystemVersion? = nil,
    buildVersion: String? = nil
  ) {
    self.name = name
    self.id = id
    self.snapshotterID = snapshotterID
    self.createdAt = createdAt
    self.fileLength = fileLength
    self.notes = notes
    self.operatingSystemVersion = operatingSystemVersion
    self.buildVersion = buildVersion
  }
}
