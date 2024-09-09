//
// MachineEntry.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  public import BushelCore

  public import BushelDataCore

  public import BushelLogging

  public import BushelMachine

  public import Foundation

  public import SwiftData

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
      let selectDescriptor = FetchDescriptor(
        predicate: #Predicate<BookmarkData> {
          $0.bookmarkID == bookmarkDataID
        }
      )
      do {
        self._bookmarkData = try modelContext?.fetch(selectDescriptor).first
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
    @Attribute(.unique)
    public var machineIdentifer: UInt64?

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

    public init(
      bookmarkDataID: UUID,
      machine: any Machine,
      updatedConfiguration: MachineConfiguration,
      osInstalled: OperatingSystemVersionComponents?,
      restoreImageID: UUID,
      name: String,
      createdAt: Date,
      lastOpenedAt: Date? = nil
    ) {
      self.bookmarkDataID = bookmarkDataID
      self.name = name
      self.restoreImageID = restoreImageID
      self.storage = updatedConfiguration.storage
      self.cpuCount = updatedConfiguration.cpuCount
      self.memory = updatedConfiguration.memory
      self.networkConfigurations = updatedConfiguration.networkConfigurations
      self.graphicsConfigurations = updatedConfiguration.graphicsConfigurations
      self.vmSystemIDRawValue = updatedConfiguration.vmSystemID.rawValue
      self.machineIdentifer = machine.machineIdentifer
      self.operatingSystemVersionString = osInstalled?.operatingSystemVersion.description
      self.buildVersion = osInstalled?.buildVersion
      self.machineIdentifer = machine.machineIdentifer
      self.createdAt = createdAt
      self.lastOpenedAt = lastOpenedAt
    }

    internal init(
      bookmarkData: BookmarkData,
      machine: any Machine,
      osInstalled: OperatingSystemVersionComponents?,
      restoreImageID: UUID,
      name: String,
      createdAt: Date,
      lastOpenedAt: Date? = nil
    ) async {
      bookmarkDataID = bookmarkData.bookmarkID
      _bookmarkData = bookmarkData
      self.name = name
      self.restoreImageID = restoreImageID
      let updatedConfiguration = await machine.updatedConfiguration
      self.storage = updatedConfiguration.storage
      self.cpuCount = updatedConfiguration.cpuCount
      self.memory = updatedConfiguration.memory
      self.networkConfigurations = updatedConfiguration.networkConfigurations
      self.graphicsConfigurations = updatedConfiguration.graphicsConfigurations
      self.vmSystemIDRawValue = updatedConfiguration.vmSystemID.rawValue
      self.machineIdentifer = machine.machineIdentifer
      self.operatingSystemVersionString = osInstalled?.operatingSystemVersion.description
      self.buildVersion = osInstalled?.buildVersion
      self.machineIdentifer = machine.machineIdentifer
      self.createdAt = createdAt
      self.lastOpenedAt = lastOpenedAt
    }
  }

  extension MachineEntry {
    public var lastOpenedDescription: String {
      self.lastOpenedAt?.description ?? ""
    }

    public var operatingSystemVersionDescription: String {
      self.operatingSystemVersionString ?? ""
    }

    public var machineIdentifierHex: String {
      self.machineIdentifer.map { String($0, radix: 16) } ?? ""
    }
  }
#endif
