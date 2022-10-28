//
// Machine.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct Machine: Identifiable, Codable {
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

  public let id: UUID
  public var specification: MachineSpecification
  public var restoreImage: RestoreImageLibraryItemFile?
  public var operatingSystem: OperatingSystemDetails?
  public var rootFileAccessor: FileAccessor?
  public var machineFactoryResultURL: URL?
  public var snapshots: [MachineSnapshot]

  public func getMachineConfigurationURL() throws -> URL? {
    try rootFileAccessor?.getURL().appendingPathComponent(Paths.machineDataDirectoryName)
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
      throw MachineError.undefinedType(
        "No available manager.",
        restoreImage?.metadata.vmSystem
      )
    }
    return try manager.session(fromMachine: self)
  }

  public var isBuilt: Bool {
    guard operatingSystem != nil else {
      return false
    }

    return true
  }

  enum CodingKeys: String, CodingKey {
    case id
    case restoreImage
    case operatingSystem
    case snapshots
    case specification
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
}

public extension Machine {
  func build() async throws -> VirtualMachineFactory {
    guard let restoreImage = restoreImage else {
      throw MachineError.undefinedType("missing restore image", self)
    }

    let vmSystem = restoreImage.metadata.vmSystem

    guard let manager = AnyImageManagers.imageManager(forSystem: vmSystem) else {
      throw MachineError.undefinedType("missing image manager", vmSystem)
    }

    return try await manager.buildMachine(self, restoreImageFile: restoreImage)
  }
}
