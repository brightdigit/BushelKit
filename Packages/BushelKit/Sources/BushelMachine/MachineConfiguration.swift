//
// MachineConfiguration.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

/// Metadata attached to a machine
public struct MachineConfiguration: Codable, OperatingSystemInstalled {
  public let restoreImageFile: InstallerImageIdentifier

  /// System ID
  public let vmSystem: VMSystemID
  public var operatingSystemVersion: OperatingSystemVersion
  public var buildVersion: String?

  /// Storage specifications
  public var storage: [MachineStorageSpecification]

  /// CPU Count
  public var cpuCount: Float = 1
  /// Amount of Memory
  public var memory: Float = (128 * 1024 * 1024 * 1024)
  /// Netwoking Configuration
  public var networkConfigurations: [NetworkConfiguration]
  /// Graphics Configuration
  public var graphicsConfigurations: [GraphicsConfiguration]
  /// Snapshot of the machine
  public var snapshots: [Snapshot]

  public init(
    restoreImageFile: InstallerImageIdentifier,
    vmSystem: VMSystemID,
    operatingSystemVersion: OperatingSystemVersion,
    buildVersion: String? = nil,
    storage: [MachineStorageSpecification] = [.default],
    cpuCount: Float = 1,
    memory: Float = (128 * 1024 * 1024 * 1024),
    networkConfigurations: [NetworkConfiguration] = [.default()],
    graphicsConfigurations: [GraphicsConfiguration] = [.default()],
    snapshots: [Snapshot] = []
  ) {
    self.restoreImageFile = restoreImageFile
    self.vmSystem = vmSystem
    self.operatingSystemVersion = operatingSystemVersion
    self.buildVersion = buildVersion
    self.storage = storage
    self.cpuCount = cpuCount
    self.memory = memory
    self.networkConfigurations = networkConfigurations
    self.graphicsConfigurations = graphicsConfigurations
    self.snapshots = snapshots
  }
}

public extension MachineConfiguration {
  init(setup: MachineSetupConfiguration, restoreImageFile: any InstallerImage) {
    self.init(
      restoreImageFile: restoreImageFile.indentifier,
      vmSystem: restoreImageFile.metadata.systemID,
      operatingSystemVersion: restoreImageFile.operatingSystemVersion,
      buildVersion: restoreImageFile.buildVersion,
      storage: setup.storage,
      cpuCount: setup.cpuCount,
      memory: setup.memory,
      networkConfigurations: setup.networkConfigurations,
      graphicsConfigurations: setup.graphicsConfigurations
    )
  }
}

extension MachineConfiguration: CodablePackage {
  public static var decoder: JSONDecoder {
    JSON.decoder
  }

  public static var encoder: JSONEncoder {
    JSON.encoder
  }

  public static var configurationFileWrapperKey: String {
    Paths.machineJSONFileName
  }

  public static var readableContentTypes: [BushelCore.FileType] {
    [.virtualMachine]
  }
}
