//
// SnapshotEntry.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelDataCore
  import BushelMachine
  import Foundation
  import SwiftData

  @Model
  public final class SnapshotEntry: Sendable {
    public var name: String
    public var snapshotID: UUID
    public var createdAt: Date
    public var isDiscardable: Bool
    public var notes: String
    public var machine: MachineEntry?

    @Attribute(originalName: "snapshotterID")
    private var snapshotterIDRawValue: String

    @Transient
    public var snapshotterID: VMSystemID {
      get {
        .init(stringLiteral: snapshotterIDRawValue)
      }
      set {
        self.snapshotterIDRawValue = newValue.rawValue
      }
    }

    @Attribute(originalName: "operatingSystemVersion")
    private var operatingSystemVersionString: String?
    public var operatingSystemVersion: OperatingSystemVersion? {
      get {
        operatingSystemVersionString.flatMap {
          try? OperatingSystemVersion(string: $0)
        }
      }
      set {
        self.operatingSystemVersionString = newValue?.description
      }
    }

    public var buildVersion: String?

    internal init(
      name: String,
      snapshotID: UUID,
      snapshotterID: SnapshotterID,
      createdAt: Date,
      isDiscardable: Bool,
      notes: String,
      operatingSystemVersion: OperatingSystemVersion? = nil,
      buildVersion: String? = nil
    ) {
      self.name = name
      self.snapshotID = snapshotID
      self.snapshotterIDRawValue = snapshotterID.rawValue
      self.createdAt = createdAt
      self.isDiscardable = isDiscardable
      self.notes = notes
      self.machine = machine
      self.operatingSystemVersion = operatingSystemVersion
      self.buildVersion = buildVersion
    }
  }

  extension SnapshotEntry {
    public var operatingSystemVersionDescription: String {
      self.operatingSystemVersionString ?? ""
    }

    public convenience init(
      _ snapshot: Snapshot,
      machine: MachineEntry,
      database: any Database,
      withOS osInstalled: (any OperatingSystemInstalled)? = nil
    ) async throws {
      self.init(
        name: snapshot.name,
        snapshotID: snapshot.id,
        snapshotterID: snapshot.snapshotterID,
        createdAt: snapshot.createdAt,
        isDiscardable: snapshot.isDiscardable,
        notes: snapshot.notes,
        operatingSystemVersion: osInstalled?.operatingSystemVersion ?? snapshot.operatingSystemVersion,
        buildVersion: osInstalled?.buildVersion ?? snapshot.buildVersion
      )
      await database.insert(self)
      self.machine = machine
      try await database.save()
    }

    public func syncronizeSnapshot(
      _ snapshot: Snapshot,
      machine: MachineEntry,
      database: any Database,
      withOS osInstalled: (any OperatingSystemInstalled)? = nil
    ) async throws {
      self.snapshotID = snapshot.id
      self.createdAt = snapshot.createdAt
      if let osInstalled {
        self.buildVersion = osInstalled.buildVersion
        self.operatingSystemVersion = osInstalled.operatingSystemVersion
      }
      self.machine = machine
      try await database.save()
    }
  }

#endif
