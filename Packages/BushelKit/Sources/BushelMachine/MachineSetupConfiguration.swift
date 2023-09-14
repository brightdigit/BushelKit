//
// MachineSetupConfiguration.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
//
// BushelMachine.swift
// Copyright (c) 2023 BrightDigit.
//
import Foundation

public struct MachineSetupConfiguration {
  public var libraryID: LibraryIdentifier?
  public var restoreImageID: UUID?
  public var storage: [MachineStorageSpecification]
  public var cpuCount: Float = 1
  public var memory: Float = (128 * 1024 * 1024 * 1024)
  public var networkConfigurations: [NetworkConfiguration]
  public var graphicsConfigurations: [GraphicsConfiguration]

  public init(
    libraryID _: LibraryIdentifier? = nil,
    restoreImageID: UUID? = nil,
    storage: [MachineStorageSpecification] = [.default],
    cpuCount: Float = 1,
    memory: Float = (128 * 1024 * 1024 * 1024),
    networkConfigurations: [NetworkConfiguration] = [.default()],
    graphicsConfigurations: [GraphicsConfiguration] = [.default()]
  ) {
    // self.libraryID = libraryID
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
    self.init(libraryID: request?.restoreImage?.libraryID, restoreImageID: request?.restoreImage?.imageID)
  }

  mutating func updating(forRequest request: MachineBuildRequest?) {
    self.restoreImageID = request?.restoreImage?.imageID
    self.libraryID = request?.restoreImage?.libraryID
  }
}
