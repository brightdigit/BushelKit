//
// Machine.swift
// Copyright (c) 2023 BrightDigit.
//

import FelinePine
import Foundation

public enum FileVersioning {
  static func dictionaryFrom(_ types: [FileVersion.Type]) -> [String: FileVersion.Type] {
    Dictionary(uniqueKeysWithValues: types.map {
      ($0.typeID, $0)
    })
  }

  public static func type(byID id: String) -> FileVersion.Type? {
    types[id]
  }

  #if os(macOS)
    static let types: [String: FileVersion.Type] = Self.dictionaryFrom([NSFileVersion.self])
  #else
    static let types: [String: FileVersion.Type] = [:]
  #endif
}

public struct Machine: Identifiable, Codable, LoggerCategorized {
  enum CodingKeys: String, CodingKey {
    case id
    case restoreImage
    case operatingSystem
    case snapshots
    case specification
  }

  public static let loggingCategory: LoggerCategory = .machines

  public let id: UUID
  public var specification: MachineSpecification
  public var restoreImage: RestoreImageLibraryItemFile?
  public var operatingSystem: OperatingSystemDetails?
  public var rootFileAccessor: FileAccessor?
  public var machineFactoryResultURL: URL?
  public var snapshots: [MachineSnapshot]

  public var isBuilt: Bool {
    guard operatingSystem != nil else {
      return false
    }

    return true
  }

  public init(loadFrom url: URL) throws {
    let data = try Data(contentsOf: url.appendingPathComponent(Paths.machineJSONFileName))
    var machine: Self = try JSON.tryDecoding(data)
    machine.rootFileAccessor = URLAccessor(url: url)
    self = machine
  }

  public init(
    id: UUID = .init(),
    restoreImage: RestoreImageLibraryItemFile? = nil,
    operatingSystem: OperatingSystemDetails? = nil,
    snapshots: [MachineSnapshot] = [],
    specification: MachineSpecification
  ) {
    self.id = id
    self.restoreImage = restoreImage
    self.operatingSystem = operatingSystem

    self.snapshots = snapshots
    self.specification = specification
  }

  public func getURL() throws -> URL? {
    try rootFileAccessor?.getURL()
  }

  public func getMachineConfigurationURL() throws -> URL? {
    try getURL()?.appendingPathComponent(Paths.machineDataDirectoryName)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encodeIfPresent(operatingSystem, forKey: .operatingSystem)
    try container.encodeIfPresent(snapshots, forKey: .snapshots)
    try container.encodeIfPresent(restoreImage, forKey: .restoreImage)
    try container.encode(specification, forKey: .specification)
  }

  public func createMachine() throws -> MachineSession? {
    let manager = (restoreImage?.metadata.vmSystem)
      .flatMap(AnyImageManagers.imageManager(forSystem:))

    guard let manager = manager else {
      throw ManagerError.undefinedType(
        "No available manager.",
        restoreImage?.metadata.vmSystem
      )
    }
    return try manager.session(fromMachine: self)
  }

  public mutating func installationCompletedAt(_ url: URL) {
    guard let metadata = restoreImage?.metadata else {
      return
    }

    operatingSystem = .init(
      type: .macOS,
      version: metadata.operatingSystemVersion,
      buildVersion: metadata.buildVersion
    )
    machineFactoryResultURL = url
  }

  public mutating func addSnapshot(using versionType: FileVersion.Type, isDiscardable: Bool = false) throws {
    guard let url = try rootFileAccessor?.getURL() else {
      throw ManagerError.undefinedType("Missing URL for Versioning", nil)
    }

    let version: FileVersion
    do {
      version = try versionType.createVersion(at: url, withContentsOf: url, isDiscardable: isDiscardable)
    } catch {
      throw ManagerError.innerError(error, "Couldn't create file version", url)
    }
    try snapshots.append(.init(fileVersion: version))
  }

  mutating func mergeWithRestoredSnapshot(_ restoredMachine: Machine) {
    let currentSnapshotCount = snapshots.count
    specification = restoredMachine.specification
    restoreImage = restoredMachine.restoreImage
    operatingSystem = restoredMachine.operatingSystem
    Self.logger.debug("merging restored snapshot with \(restoredMachine.snapshots.count) snapshots with current version that has \(currentSnapshotCount) snapshots")
  }

  func save(toDirectoryURL url: URL?) throws -> URL {
    guard let url = try url ?? rootFileAccessor?.getURL() else {
      throw ManagerError.undefinedType("Missing URL for Versioning", nil)
    }
    let machineFileURL = url.appendingPathComponent(Paths.machineJSONFileName)
    let data = try JSON.encoder.encode(self)
    try data.write(to: machineFileURL)
    return url
  }

  @discardableResult
  public mutating func restoreSnapshot(withID id: MachineSnapshot.ID) async throws -> URL {
    guard let url = try rootFileAccessor?.getURL() else {
      throw ManagerError.undefinedType("Missing URL for Versioning", nil)
    }
    let snapshot = snapshots.first {
      $0.id == id
    }

    guard let snapshot = snapshot else {
      throw ManagerError.undefinedType("Snapshot not found.", id)
    }

    guard let versionType = FileVersioning.type(byID: snapshot.typeID) else {
      throw ManagerError.undefinedType("Snapshots not supported in OS.", nil)
    }

    guard let fileVersion = try versionType.fetchVersion(at: url, withID: id) else {
      throw ManagerError.undefinedType("Can't find FileVersion with ID.", id)
    }
    try await fileVersion.save(to: url)
    let restoredMachine = try Machine(loadFrom: url)
    mergeWithRestoredSnapshot(restoredMachine)
    return try save(toDirectoryURL: url)
  }

  public mutating func exportSnapshot() throws {}

  public mutating func deleteSnapshot() throws {}
}

public extension Machine {
  func build() async throws -> VirtualMachineFactory {
    guard let restoreImage = restoreImage else {
      throw ManagerError.undefinedType("missing restore image", self)
    }

    let vmSystem = restoreImage.metadata.vmSystem

    guard let manager = AnyImageManagers.imageManager(forSystem: vmSystem) else {
      throw ManagerError.undefinedType("missing image manager", vmSystem)
    }

    return try await manager.buildMachine(self, restoreImageFile: restoreImage)
  }
}
