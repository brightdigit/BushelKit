//
// SnapshotEntry.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelMachine
  import Foundation
  import SwiftData

  @Model
  public final class SnapshotEntry {
    public var name: String
    public var snapshotID: UUID
    public var createdAt: Date
    public var fileLength: Int
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
      fileLength: Int,
      isDiscardable: Bool,
      notes: String,
      operatingSystemVersion: OperatingSystemVersion? = nil,
      buildVersion: String? = nil
    ) {
      self.name = name
      self.snapshotID = snapshotID
      self.snapshotterIDRawValue = snapshotterID.rawValue
      self.createdAt = createdAt
      self.fileLength = fileLength
      self.isDiscardable = isDiscardable
      self.notes = notes
      self.machine = machine
      self.operatingSystemVersion = operatingSystemVersion
      self.buildVersion = buildVersion
    }
  }

  public extension SnapshotEntry {
    var operatingSystemVersionDescription: String {
      self.operatingSystemVersionString ?? ""
    }

    // swiftlint:disable:next function_default_parameter_at_end
    @MainActor
    convenience init(
      _ snapshot: Snapshot,
      machine: MachineEntry,
      osInstalled: OperatingSystemInstalled? = nil,
      using context: ModelContext
    ) throws {
      self.init(
        name: snapshot.name,
        snapshotID: snapshot.id,
        snapshotterID: snapshot.snapshotterID,
        createdAt: snapshot.createdAt,
        fileLength: snapshot.fileLength,
        isDiscardable: snapshot.isDiscardable,
        notes: snapshot.notes,
        operatingSystemVersion: osInstalled?.operatingSystemVersion ?? snapshot.operatingSystemVersion,
        buildVersion: osInstalled?.buildVersion ?? snapshot.buildVersion
      )
      context.insert(self)
      self.machine = machine
      try context.save()
    }

    #warning("Remove @MainActor")
    @MainActor
    // swiftlint:disable:next function_default_parameter_at_end
    func syncronizeSnapshot(
      _ snapshot: Snapshot,
      machine: MachineEntry,
      osInstalled: OperatingSystemInstalled? = nil,
      using context: ModelContext
    ) throws {
      self.snapshotID = snapshot.id
      self.createdAt = snapshot.createdAt
      self.fileLength = snapshot.fileLength
      if let osInstalled {
        self.buildVersion = osInstalled.buildVersion
        self.operatingSystemVersion = osInstalled.operatingSystemVersion
      }
      self.machine = machine
      try context.save()
    }
  }

#endif
