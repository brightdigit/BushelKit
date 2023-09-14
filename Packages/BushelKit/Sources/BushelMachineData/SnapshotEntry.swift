//
// SnapshotEntry.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)
  import BushelMachine
  import Foundation
  import SwiftData

  @Model
  public final class SnapshotEntry {
    public var snapshotID: UUID
    public var createdAt: Date
    public var fileLength: Int
    public var machine: MachineEntry?

    public var buildVersion: String?
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

    internal init(
      snapshotID: UUID,
      createdAt: Date,
      fileLength: Int,
      buildVersion: String?,
      operatingSystemVersion: OperatingSystemVersion?
    ) {
      self.snapshotID = snapshotID
      self.createdAt = createdAt
      self.fileLength = fileLength
      self.buildVersion = buildVersion
      self.operatingSystemVersion = operatingSystemVersion
    }
  }

  public extension SnapshotEntry {
    var operatingSystemVersionDescription: String {
      self.operatingSystemVersionString ?? ""
    }

    convenience init(
      machine: MachineEntry,
      snapshot: Snapshot,
      osInstalled: OperatingSystemInstalled?,
      using context: ModelContext
    ) throws {
      self.init(
        snapshotID: snapshot.id,
        createdAt: snapshot.createdAt,
        fileLength: snapshot.fileLength,
        buildVersion: osInstalled?.buildVersion,
        operatingSystemVersion: osInstalled?.operatingSystemVersion
      )
      context.insert(self)
      self.machine = machine
      try context.save()
    }

    func syncronizeSnapshot(
      _ snapshot: Snapshot,
      machine: MachineEntry,
      osInstalled: OperatingSystemInstalled?,
      using context: ModelContext
    ) throws {
      self.snapshotID = snapshot.id
      self.createdAt = snapshot.createdAt
      self.fileLength = snapshot.fileLength
      self.buildVersion = osInstalled?.buildVersion ?? self.buildVersion
      self.operatingSystemVersion = osInstalled?.operatingSystemVersion ?? self.operatingSystemVersion
      self.machine = machine
      try context.save()
    }
  }

#endif
