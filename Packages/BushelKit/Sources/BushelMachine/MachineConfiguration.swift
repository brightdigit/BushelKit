//
// MachineConfiguration.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

/// Metadata attached to a machine
public struct MachineConfiguration: Codable {
  public let restoreImageFile: InstallerImageIdentifier
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
  /// System ID
  public let vmSystem: VMSystemID
  /// Snapshot of the machine
  public var snapshots: [Snapshot]

  public init(
    restoreImageFile: InstallerImageIdentifier,
    systemID: VMSystemID,
    storage: [MachineStorageSpecification] = [.default],
    cpuCount: Float = 1,
    memory: Float = (128 * 1024 * 1024 * 1024),
    networkConfigurations: [NetworkConfiguration] = [.default()],
    graphicsConfigurations: [GraphicsConfiguration] = [.default()],
    snapshots: [Snapshot] = []
  ) {
    self.restoreImageFile = restoreImageFile
    self.vmSystem = systemID
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
      systemID: restoreImageFile.metadata.systemID,
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
