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
  public let snapshotSystemID: SnapshotterID
  public let operatingSystemVersion: OSVer
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

  public let videos: [RecordedVideo]?
  public let images: [RecordedImage]?

  public let restoreImageFile: InstallerImageIdentifier

  public var operatingSystemVersionComponents: OperatingSystemVersionComponents {
    .init(buildVersion: buildVersion, operatingSystemVersion: operatingSystemVersion)
  }

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
  public static var decoder: JSONDecoder {
    JSON.decoder
  }

  public static var encoder: JSONEncoder {
    JSON.encoder
  }

  public static var configurationFileWrapperKey: String {
    URL.bushel.paths.machineJSONFileName
  }

  public static var readableContentTypes: [FileType] {
    [.virtualMachine]
  }
}

extension MachineConfiguration {
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
