//
//  MachineConfiguration.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

public import BushelFoundation
internal import BushelUtilities
public import Foundation
public import OSVer
public import RadiantDocs
internal import RadiantKit

// swiftlint:disable file_length

/// Metadata attached to a machine
public struct MachineConfiguration: Codable, OperatingSystemInstalled, Sendable {
  /// System ID
  public let vmSystemID: VMSystemID
  /// Identifier of the snapshot system used to capture and restore machine state.
  public let snapshotSystemID: SnapshotterID
  /// Version of the operating system installed on the machine.
  public let operatingSystemVersion: OSVer
  /// Build version string of the installed operating system, if known.
  public let buildVersion: String?

  /// Storage specifications
  public let storage: [MachineStorageSpecification]

  /// CPU Count
  public let cpuCount: Int
  /// Amount of Memory
  public let memory: Int
  /// Networking Configuration
  public let networkConfigurations: [NetworkConfiguration]
  /// Graphics Configuration
  public let graphicsConfigurations: [GraphicsConfiguration]
  /// Snapshot of the machine
  public let snapshots: [Snapshot]

  /// Videos recorded from the machine, if any.
  public let videos: [RecordedVideo]?
  /// Screenshot images captured from the machine, if any.
  public let images: [RecordedImage]?

  /// Identifier of the installer image used to restore or install this machine.
  public let restoreImageFile: InstallerImageIdentifier

  /// The operating system version and build combined into version components.
  public var operatingSystemVersionComponents: OperatingSystemVersionComponents {
    .init(buildVersion: buildVersion, operatingSystemVersion: operatingSystemVersion)
  }

  /// Creates a machine configuration from its individual specifications.
  ///
  /// - Parameters:
  ///   - restoreImageFile: Identifier of the installer image used to restore or install the machine.
  ///   - vmSystemID: Identifier of the virtual machine system.
  ///   - snapshotSystemID: Identifier of the snapshot system.
  ///   - operatingSystemVersion: Version of the operating system installed on the machine.
  ///   - buildVersion: Build version string of the operating system, if known.
  ///   - storage: Storage device specifications for the machine.
  ///   - cpuCount: Number of CPU cores allocated to the machine.
  ///   - memory: Amount of memory in bytes allocated to the machine.
  ///   - networkConfigurations: Network device configurations for the machine.
  ///   - graphicsConfigurations: Graphics device configurations for the machine.
  ///   - snapshots: Snapshots associated with the machine.
  ///   - videos: Videos recorded from the machine.
  ///   - images: Screenshot images captured from the machine.
  public init(
    restoreImageFile: InstallerImageIdentifier,
    vmSystemID: VMSystemID,
    snapshotSystemID: SnapshotterID,
    operatingSystemVersion: OSVer,
    buildVersion: String? = nil,
    storage: [MachineStorageSpecification],
    cpuCount: Int = 1,
    memory: Int = (128 * 1_024 * 1_024 * 1_024),
    networkConfigurations: [NetworkConfiguration] = [.default()],
    graphicsConfigurations: [GraphicsConfiguration] = [.default()],
    snapshots: [Snapshot] = [],
    videos: [RecordedVideo] = [],
    images: [RecordedImage] = []
  ) {
    assert(
      memory.isMultiple(of: 1_024 * 1_024),
      "Memory is not correct multiple of 1MiB. Should be \(memory.roundToMultiple(of: 1_024 * 1_024))"
    )
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
    self.videos = videos
    self.images = images
  }
}

extension MachineConfiguration {
  /// Initializes a `MachineConfiguration`
  /// rom a `MachineSetupConfiguration` and a `RestorableInstallerImage`.
  ///
  /// - Parameters:
  ///   - setup: The `MachineSetupConfiguration` to use for initialization.
  ///   - restoreImageFile: The `InstallerImage` to use for initialization.
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

  /// Initializes a `MachineConfiguration` from a `Snapshot` and the original `MachineConfiguration`.
  ///
  /// - Parameters:
  ///   - snapshot: The `Snapshot` to use for initialization.
  ///   - original: The original `MachineConfiguration` to use for initialization.
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
  /// The JSON decoder used to decode a machine configuration.
  public static var decoder: JSONDecoder {
    JSON.decoder
  }

  /// The JSON encoder used to encode a machine configuration.
  public static var encoder: JSONEncoder {
    JSON.encoder
  }

  /// The file name used to store the machine configuration within its package.
  public static var configurationFileWrapperKey: String {
    URL.bushel.paths.machineJSONFileName
  }

  /// The content types this configuration can be read from.
  public static var readableContentTypes: [FileType] {
    [.virtualMachine]
  }
}

extension MachineConfiguration {
  /// Creates a machine configuration from an existing one, replacing its snapshots.
  ///
  /// - Parameters:
  ///   - original: The configuration to copy.
  ///   - withSnapshots: A closure that transforms the original snapshots into the new snapshots.
  @available(*, deprecated)
  public init(
    original: MachineConfiguration,
    _ withSnapshots: @escaping @Sendable ([Snapshot]) -> [Snapshot]
  ) {
    self.init(
      restoreImageFile: original.restoreImageFile,
      vmSystemID: original.vmSystemID,
      snapshotSystemID: original.snapshotSystemID,
      operatingSystemVersion: original.operatingSystemVersion,
      buildVersion: original.buildVersion,
      storage: original.storage,
      cpuCount: Int(original.cpuCount),
      memory: Int(original.memory),
      networkConfigurations: original.networkConfigurations,
      graphicsConfigurations: original.graphicsConfigurations,
      snapshots: withSnapshots(original.snapshots),
      videos: original.videos ?? [],
      images: original.images ?? []
    )
  }

  /// Updates the `images` property of the `MachineConfiguration` using the provided closure.
  ///
  /// - Parameter closure: A closure that takes the current array of `RecordedImage` values
  /// and returns a new array of `RecordedImage` values.
  /// - Returns: A new `MachineConfiguration` with the updated `images` property.
  public func updatesImage(_ closure: @escaping @Sendable ([RecordedImage]) -> [RecordedImage])
    -> MachineConfiguration
  {
    .init(
      restoreImageFile: self.restoreImageFile,
      vmSystemID: self.vmSystemID,
      snapshotSystemID: self.snapshotSystemID,
      operatingSystemVersion: self.operatingSystemVersion,
      buildVersion: self.buildVersion,
      storage: self.storage,
      cpuCount: Int(self.cpuCount),
      memory: Int(self.memory),
      networkConfigurations: self.networkConfigurations,
      graphicsConfigurations: self.graphicsConfigurations,
      snapshots: self.snapshots,
      videos: self.videos ?? [],
      images: closure(self.images ?? [])
    )
  }

  /// Updates the `videos` property of the `MachineConfiguration` using the provided closure.
  ///
  /// - Parameter closure: A closure that takes the current array of `RecordedVideo` values
  /// and returns a new array of `RecordedVideo` values.
  /// - Returns: A new `MachineConfiguration` with the updated `videos` property.
  public func updatesVideos(_ closure: @escaping @Sendable ([RecordedVideo]) -> [RecordedVideo])
    -> MachineConfiguration
  {
    .init(
      restoreImageFile: self.restoreImageFile,
      vmSystemID: self.vmSystemID,
      snapshotSystemID: self.snapshotSystemID,
      operatingSystemVersion: self.operatingSystemVersion,
      buildVersion: self.buildVersion,
      storage: self.storage,
      cpuCount: Int(self.cpuCount),
      memory: Int(self.memory),
      networkConfigurations: self.networkConfigurations,
      graphicsConfigurations: self.graphicsConfigurations,
      snapshots: self.snapshots,
      videos: closure(self.videos ?? []),
      images: self.images ?? []
    )
  }
}
