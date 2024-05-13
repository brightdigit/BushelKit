//
//  MachineConfiguration.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import BushelCore
import Foundation

/// Metadata attached to a machine
public struct MachineConfiguration: Codable, OperatingSystemInstalled, Sendable {
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
  public var memory: Int = (128 * 1_024 * 1_024 * 1_024)
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
    storage: [MachineStorageSpecification],
    cpuCount: Int = 1,
    memory: Int = (128 * 1_024 * 1_024 * 1_024),
    networkConfigurations: [NetworkConfiguration] = [.default()],
    graphicsConfigurations: [GraphicsConfiguration] = [.default()],
    snapshots: [Snapshot] = []
  ) {
    assert(memory.isMultiple(of: 1_024 * 1_024))
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

extension MachineConfiguration {
  public init(setup: MachineSetupConfiguration, restoreImageFile: any InstallerImage) {
    self.init(
      restoreImageFile: restoreImageFile.identifier,
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

  public init(snapshot: Snapshot, original: MachineConfiguration) {
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
    URL.bushel.paths.machineJSONFileName
  }

  public static var readableContentTypes: [BushelCore.FileType] {
    [.virtualMachine]
  }
}
