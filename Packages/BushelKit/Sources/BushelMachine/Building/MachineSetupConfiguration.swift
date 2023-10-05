//
// MachineSetupConfiguration.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

/// Writable configuration used for setting up and configuring a new machine.
public struct MachineSetupConfiguration {
  /// Identifier to access the install image
  public var libraryID: LibraryIdentifier?
  /// Optional identifier to the restore library
  public var restoreImageID: UUID?
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

  public var snapshotSystemID: SnapshotterID = "fileVersion"

  public init(
    libraryID: LibraryIdentifier? = nil,
    restoreImageID: UUID? = nil,
    storage: [MachineStorageSpecification] = [.default],
    cpuCount: Float = 1,
    memory: Float = (128 * 1024 * 1024 * 1024),
    networkConfigurations: [NetworkConfiguration] = [.default()],
    graphicsConfigurations: [GraphicsConfiguration] = [.default()]
  ) {
    self.libraryID = libraryID
    self.restoreImageID = restoreImageID
    self.storage = storage
    self.cpuCount = cpuCount
    self.memory = memory
    self.networkConfigurations = networkConfigurations
    self.graphicsConfigurations = graphicsConfigurations
  }
}

public extension MachineSetupConfiguration {
  var primaryStorage: MachineStorageSpecification {
    get {
      storage.first ?? .default
    }
    set {
      storage[0] = newValue
    }
  }

  var primaryStorageSizeFloat: Float {
    get {
      Float(self.primaryStorage.size)
    }
    set {
      self.primaryStorage.size = .init(newValue)
    }
  }

  init(request: MachineBuildRequest?) {
    self.init(
      libraryID: request?.restoreImage?.libraryID,
      restoreImageID: request?.restoreImage?.imageID
    )
  }

  mutating func updating(forRequest request: MachineBuildRequest?) {
    self.restoreImageID = request?.restoreImage?.imageID
    self.libraryID = request?.restoreImage?.libraryID
  }
}
