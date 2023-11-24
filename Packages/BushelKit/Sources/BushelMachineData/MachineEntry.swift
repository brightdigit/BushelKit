//
// MachineEntry.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelDataCore
  import BushelLogging
  import BushelMachine
  import Foundation
  import SwiftData

  @Model
  public final class MachineEntry: Loggable {
    @Attribute(.unique)
    public private(set) var bookmarkDataID: UUID

    @Transient
    private var _bookmarkData: BookmarkData?

    @Transient
    public var bookmarkData: BookmarkData? {
      if let bookmarkData = self._bookmarkData {
        return bookmarkData
      }
      let descriptor = FetchDescriptor(
        predicate: #Predicate<BookmarkData> {
          $0.bookmarkID == bookmarkDataID
        }
      )
      do {
        self._bookmarkData = try modelContext?.fetch(descriptor).first
      } catch {
        assertionFailure(error: error)
      }
      assert(self._bookmarkData != nil)
      return self._bookmarkData
    }

    public var name: String
    public var restoreImageID: UUID?
    public var storage: [MachineStorageSpecification]
    public var cpuCount: Int
    public var memory: Int
    public var networkConfigurations: [NetworkConfiguration]
    public var graphicsConfigurations: [GraphicsConfiguration]

    @Attribute(originalName: "vmSystemID")
    private var vmSystemIDRawValue: String

    @Transient
    public var vmSystemID: VMSystemID {
      get {
        .init(stringLiteral: vmSystemIDRawValue)
      }
      set {
        self.vmSystemIDRawValue = newValue.rawValue
      }
    }

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

    public var createdAt: Date
    public var lastOpenedAt: Date?

    @Relationship(deleteRule: .cascade, inverse: \SnapshotEntry.machine)
    public private(set) var snapshots: [SnapshotEntry]?

    internal init(
      bookmarkData: BookmarkData,
      machine: any Machine,
      osInstalled: OperatingSystemInstalled?,
      restoreImageID: UUID,
      name: String,
      createdAt: Date,
      lastOpenedAt: Date? = nil
    ) {
      bookmarkDataID = bookmarkData.bookmarkID
      _bookmarkData = bookmarkData
      self.name = name
      self.restoreImageID = restoreImageID
      self.storage = machine.configuration.storage
      self.cpuCount = machine.configuration.cpuCount
      self.memory = machine.configuration.memory
      self.networkConfigurations = machine.configuration.networkConfigurations
      self.graphicsConfigurations = machine.configuration.graphicsConfigurations
      self.vmSystemIDRawValue = machine.configuration.vmSystemID.rawValue
      self.operatingSystemVersionString = osInstalled?.operatingSystemVersion.description
      self.buildVersion = osInstalled?.buildVersion
      self.createdAt = createdAt
      self.lastOpenedAt = lastOpenedAt
    }
  }

  public extension MachineEntry {
    var lastOpenedDescription: String {
      self.lastOpenedAt?.description ?? ""
    }

    var operatingSystemVersionDescription: String {
      self.operatingSystemVersionString ?? ""
    }
  }
#endif
