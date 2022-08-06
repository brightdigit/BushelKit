//
// Machine.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

import Foundation

public struct Machine: Identifiable, Codable {
  public init(id: UUID = .init(), restoreImage: RestoreImageLibraryItemFile? = nil, operatingSystem: OperatingSystemDetails? = nil) {
    self.id = id
    self.restoreImage = restoreImage
    self.operatingSystem = operatingSystem
  }

  public let id: UUID
  public var restoreImage: RestoreImageLibraryItemFile?
  public var operatingSystem: OperatingSystemDetails?
  public var rootFileAccessor: FileAccessor?
  public var machineFactoryResultURL: URL?

  public func getMachineConfigurationURL() throws -> URL? {
    try rootFileAccessor?.getURL().appendingPathComponent("data")
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encodeIfPresent(restoreImage, forKey: .restoreImage)
    try container.encodeIfPresent(operatingSystem, forKey: .operatingSystem)
  }

  public func createMachine() throws -> MachineSession? {
    let manager = (restoreImage?.metadata.vmSystem).flatMap(AnyImageManagers.imageManager(forSystem:))

    guard let manager = manager else {
      throw MachineError.undefinedType("No available manager.", restoreImage?.metadata.vmSystem)
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
  }

  mutating func osInstallationCompleted() {}

  public mutating func installationCompletedAt(_ url: URL) {
    guard let metadata = restoreImage?.metadata else {
      return
    }

    operatingSystem = .init(type: .macOS, version: metadata.operatingSystemVersion, buildVersion: metadata.buildVersion)
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
