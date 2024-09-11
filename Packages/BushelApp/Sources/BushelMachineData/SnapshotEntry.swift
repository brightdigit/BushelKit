//
// SnapshotEntry.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  public import BushelCore

  import BushelDataCore

  public import DataThespian

  public import BushelMachine

  public import Foundation

  public import SwiftData

  @Model
  public final class SnapshotEntry {
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
      withOS osInstalled: OperatingSystemVersionComponents? = nil
    ) {
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
    }

    public static func syncronizeSnapshotModel(
      _ model: ModelID<SnapshotEntry>,
      with snapshot: Snapshot,
      machineModel: ModelID<MachineEntry>,
      using database: any Database,
      withOS osInstalled: OperatingSystemVersionComponents? = nil
    ) async throws {
      try await database.with(model) { snapshotEntry in
        try snapshotEntry.syncronizeSnapshot(snapshot, model: machineModel, withOS: osInstalled)
      }
    }

    public func syncronizeSnapshot(
      _ snapshot: Snapshot,
      model _: ModelID<MachineEntry>,
      withOS osInstalled: OperatingSystemVersionComponents? = nil
    ) throws {
      self.snapshotID = snapshot.id
      self.createdAt = snapshot.createdAt
      if let osInstalled {
        self.buildVersion = osInstalled.buildVersion
        self.operatingSystemVersion = osInstalled.operatingSystemVersion
      }
      self.machine = machine
    }

    public func syncronizeSnapshot(
      _ snapshot: Snapshot,
      withOS osInstalled: OperatingSystemVersionComponents? = nil
    ) throws {
      self.snapshotID = snapshot.id
      self.createdAt = snapshot.createdAt
      if let osInstalled {
        self.buildVersion = osInstalled.buildVersion
        self.operatingSystemVersion = osInstalled.operatingSystemVersion
      }
    }

    public func syncronizeSnapshot(
      _ snapshot: Snapshot,
      model _: ModelID<MachineEntry>,
      database _: any Database,
      withOS osInstalled: OperatingSystemVersionComponents? = nil
    ) async throws {
      self.snapshotID = snapshot.id
      self.createdAt = snapshot.createdAt
      if let osInstalled {
        self.buildVersion = osInstalled.buildVersion
        self.operatingSystemVersion = osInstalled.operatingSystemVersion
      }
      self.machine = machine
    }
  }

#endif
