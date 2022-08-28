//
// VirtualizationImageManager.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/21/22.
//

import BushelMachine
import Foundation
import UniformTypeIdentifiers
import Virtualization

public extension VMSystemID {
  static let macOS: VMSystemID = "macOSApple"
}

public extension AnyImageManagers {
  static let vzMacOS: AnyImageManager = VirtualizationImageManager()
}

public struct VirtualizationImageManager: ImageManager {
  static let defaultNamePrefix = "macOS"

  public func defaultName(for metadata: BushelMachine.ImageMetadata) -> String {
    guard let codeName = OperatingSystemCodeName(operatingSystemVersion: metadata.operatingSystemVersion) else {
      return "\(Self.defaultNamePrefix) \(metadata.operatingSystemVersion) (\(metadata.buildVersion))"
    }

    return "\(Self.defaultNamePrefix) \(codeName.name) \(metadata.operatingSystemVersion) (\(metadata.buildVersion))"
  }

  public static let restoreImageContentTypes = UTType.ipswTypes
  public static var systemID = VMSystemID.macOS

  public init() {}

  public func loadFromAccessor(_ accessor: FileAccessor) async throws -> VZMacOSRestoreImage {
    try await VZMacOSRestoreImage.loadFromURL(accessor.getURL())
  }

  public func containerFor(image: VZMacOSRestoreImage, fileAccessor: FileAccessor?) async throws -> ImageContainer {
    try await VirtualizationMacOSRestoreImage(vzRestoreImage: image, fileAccessor: fileAccessor)
  }

  public func validateSession(fromMachine machine: Machine) throws {
    guard let configurationURL = try machine.getMachineConfigurationURL() else {
      throw VirtualizationError.undefinedType("Missing configurationURL for session", self)
    }

    try VirtualizationSession.validate(fromConfigurationURL: configurationURL)
  }

  public func session(fromMachine machine: Machine) throws -> MachineSession {
    guard let configurationURL = try machine.getMachineConfigurationURL() else {
      throw VirtualizationError.undefinedType("Missing configurationURL for session", self)
    }

    return try VirtualizationSession(fromConfigurationURL: configurationURL)
  }

  public func buildMachine(_ machine: Machine, restoreImage: VZMacOSRestoreImage) -> VirtualMachineFactory {
    VirtualMacOSMachineFactory(machine: machine, restoreImage: restoreImage)
  }

  public func restoreImage(from fileAccessor: FileAccessor) async throws -> VZMacOSRestoreImage {
    try await VZMacOSRestoreImage.loadFromURL(fileAccessor.getURL())
  }
}
