//
// Machine.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
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
  public var configurationURL: URL?

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

    guard let vmSystem = restoreImage?.metadata.vmSystem else {
      return false
    }

    guard let configurationURL = configurationURL else {
      return false
    }

    return true
  }

  enum CodingKeys: String, CodingKey {
    case id
    case restoreImage
    case configurationURL
    case operatingSystem
  }

  public mutating func setConfiguration(_ configuration: MachineConfiguration) {
    configurationURL = configuration.currentURL
  }

  mutating func osInstallationCompleted(withConfiguration configuration: MachineConfiguration) {
    guard let metadata = restoreImage?.metadata else {
      return
    }
    setConfiguration(configuration)
    operatingSystem = .init(type: .macOS, version: metadata.operatingSystemVersion, buildVersion: metadata.buildVersion)
  }

  mutating func beginLoadingFromURL(_ url: URL) {
    configurationURL = url
  }
  // var configuration : MachineConfiguration?
  // var installer : ImageInstaller?
}

public extension Machine {
  func createInstaller() async throws -> ImageInstaller {
    guard let restoreImage = restoreImage else {
      throw MachineError.undefinedType("Missing restore image for installer", self)
    }
    return try await restoreImage.installer()
  }

  func build(withInstaller installer: ImageInstaller) throws -> MachineConfiguration {
    try installer.setupMachine(self)
  }

  func startInstallation(with installer: ImageInstaller, using configuration: MachineConfiguration) throws -> VirtualInstaller {
    try installer.beginInstaller(configuration: configuration)
  }
}
