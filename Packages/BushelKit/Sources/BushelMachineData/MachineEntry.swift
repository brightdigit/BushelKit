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
  public final class MachineEntry: LoggerCategorized {
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

    convenience init(
      bookmarkData: BookmarkData,
      machine: any Machine,
      osInstalled: OperatingSystemInstalled?,
      restoreImageID: UUID,
      name: String,
      createdAt: Date,
      lastOpenedAt: Date?,
      withContext context: ModelContext
    ) throws {
      self.init(
        bookmarkData: bookmarkData,
        machine: machine,
        osInstalled: osInstalled,
        restoreImageID: restoreImageID,
        name: name,
        createdAt: createdAt,
        lastOpenedAt: lastOpenedAt
      )
      context.insert(self)
      try context.save()
      try machine.configuration.snapshots.forEach {
        _ = try SnapshotEntry($0, machine: self, osInstalled: osInstalled, using: context)
      }
      try context.save()
    }

    #warning("Remove @MainActor")
    @MainActor
    func synchronizeWith(
      _ machine: any Machine,
      osInstalled: OperatingSystemInstalled?,
      using context: ModelContext
    ) throws {
      let entryMap: [UUID: SnapshotEntry] = .init(uniqueKeysWithValues: snapshots?.map {
        ($0.snapshotID, $0)
      } ?? [])

      let imageMap: [UUID: Snapshot] = .init(uniqueKeysWithValues: machine.configuration.snapshots.map {
        ($0.id, $0)
      })

      let entryIDsToUpdate = Set(entryMap.keys).intersection(imageMap.keys)
      let entryIDsToDelete = Set(entryMap.keys).subtracting(imageMap.keys)
      let libraryIDsToInsert = Set(imageMap.keys).subtracting(entryMap.keys)

      let entriesToDelete = entryIDsToDelete.compactMap { entryMap[$0] }
      let libraryItemsToInsert = libraryIDsToInsert.compactMap { imageMap[$0] }

      try entryIDsToUpdate.forEach { entryID in
        guard let entry = entryMap[entryID], let image = imageMap[entryID] else {
          assertionFailure("synconized ids not found for \(entryID)")
          Self.logger.error("synconized ids not found for \(entryID)")
          return
        }
        try entry.syncronizeSnapshot(image, machine: self, osInstalled: osInstalled, using: context)
      }

      try libraryItemsToInsert.forEach {
        _ = try SnapshotEntry(
          $0,
          machine: self,
          osInstalled: osInstalled,
          using: context
        )
      }

      entriesToDelete.forEach(context.delete)
      try context.save()
    }
  }
#endif
