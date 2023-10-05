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
  public let vmSystemID: VMSystemID
  public let snapshotSystemID: SnapshotterID
  public var operatingSystemVersion: OperatingSystemVersion
  public var buildVersion: String?

  /// Storage specifications
  public var storage: [MachineStorageSpecification]

  /// CPU Count
  public var cpuCount: Int = 1
  /// Amount of Memory
  public var memory: Int = (128 * 1024 * 1024 * 1024)
  /// Netwoking Configuration
  public var networkConfigurations: [NetworkConfiguration]
  /// Graphics Configuration
  public var graphicsConfigurations: [GraphicsConfiguration]
  /// Snapshot of the machine
  public var snapshots: [Snapshot]

  public init(
    restoreImageFile: InstallerImageIdentifier,
    vmSystemID: VMSystemID,
    snapshotSystemID: SnapshotterID,
    operatingSystemVersion: OperatingSystemVersion,
    buildVersion: String? = nil,
    storage: [MachineStorageSpecification] = [.default],
    cpuCount: Int = 1,
    memory: Int = (128 * 1024 * 1024 * 1024),
    networkConfigurations: [NetworkConfiguration] = [.default()],
    graphicsConfigurations: [GraphicsConfiguration] = [.default()],
    snapshots: [Snapshot] = []
  ) {
    self.restoreImageFile = restoreImageFile
    self.vmSystemID = vmSystemID
    self.snapshotSystemID = snapshotSystemID
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
      vmSystemID: restoreImageFile.metadata.vmSystemID,
      snapshotSystemID: setup.snapshotSystemID,
      operatingSystemVersion: restoreImageFile.operatingSystemVersion,
      buildVersion: restoreImageFile.buildVersion,
      storage: setup.storage,
      cpuCount: Int(setup.cpuCount),
      memory: Int(setup.memory),
      networkConfigurations: setup.networkConfigurations,
      graphicsConfigurations: setup.graphicsConfigurations
    )
  }

  init(snapshot: Snapshot, original: MachineConfiguration) {
    self.init(
      restoreImageFile: original.restoreImageFile,
      vmSystemID: original.vmSystemID,
      snapshotSystemID: original.snapshotSystemID,
      operatingSystemVersion: snapshot.operatingSystemVersion ?? original.operatingSystemVersion,
      buildVersion: snapshot.buildVersion,
      storage: original.storage,
      cpuCount: Int(original.cpuCount),
      memory: Int(original.memory),
      networkConfigurations: original.networkConfigurations,
      graphicsConfigurations: original.graphicsConfigurations
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
