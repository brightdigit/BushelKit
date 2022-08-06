//
// VirtualizationImageManager.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
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
  public static let restoreImageContentTypes = UTType.ipswTypes
  public static var systemID = VMSystemID.macOS
  public func validateAt(_: URL) throws {}

  public init() {}

  public func loadFromAccessor(_ accessor: FileAccessor) async throws -> VZMacOSRestoreImage {
    try await VZMacOSRestoreImage.loadFromURL(accessor.getURL())
  }

  public func imageContainer(vzRestoreImage: VZMacOSRestoreImage, sha256: SHA256?, fileAccessor: FileAccessor?) async throws -> ImageContainer {
    try await VirtualizationMacOSRestoreImage(vzRestoreImage: vzRestoreImage, sha256: sha256, fileAccessor: fileAccessor)
  }

  public func session(fromMachine machine: Machine) throws -> MachineSession {
    guard let configurationURL = try machine.getMachineConfigurationURL() else {
      throw VirtualizationError.undefinedType("Missing configurationURL for session", self)
    }

    let configuration = try VZVirtualMachineConfiguration(contentsOfDirectory: configurationURL)
    try configuration.validate()
    return VZVirtualMachine(configuration: configuration)
  }

  public func buildMachine(_ machine: Machine, restoreImage: VZMacOSRestoreImage) -> VirtualMachineFactory {
    VirtualMacOSMachineFactory(machine: machine, restoreImage: restoreImage)
  }

  public func restoreImage(from fileAccessor: FileAccessor) async throws -> VZMacOSRestoreImage {
    try await VZMacOSRestoreImage.loadFromURL(fileAccessor.getURL())
  }
}
