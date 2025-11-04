//
//  MachineSetupConfiguration.swift
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
public import Foundation

/// Writable configuration used for setting up and configuring a new machine.
public struct MachineSetupConfiguration: Sendable {
  /// Identifier to access the install image
  public var libraryID: LibraryIdentifier?
  /// Optional identifier to the restore library
  public var restoreImageID: UUID?
  /// Storage specifications
  public var storage: [MachineStorageSpecification]
  /// CPU Count
  public var cpuCount: Float
  /// Amount of Memory
  public var memory: Float
  /// Networking Configuration
  public var networkConfigurations: [NetworkConfiguration]
  /// Graphics Configuration
  public var graphicsConfigurations: [GraphicsConfiguration]

  public var snapshotSystemID: SnapshotterID = .fileVersion

  /// Initializes a new `MachineSetupConfiguration` with the default storage specification
  /// for the provided `MachineSystem`.
  /// - Parameter system: The `MachineSystem` to use for the default storage specification.
  @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
  public init(system: any MachineSystem) {
    self.init(storage: [.default(forSystem: system)])
  }

  /// Initializes a new `MachineSetupConfiguration`.
  /// - Parameters:
  ///   - libraryID: Identifier to access the install image.
  ///   - restoreImageID: Optional identifier to the restore library.
  ///   - storage: Storage specifications.
  ///   - cpuCount: CPU Count.
  ///   - memory: Amount of Memory.
  ///   - networkConfigurations: Networking Configuration.
  ///   - graphicsConfigurations: Graphics Configuration.
  public init(
    libraryID: LibraryIdentifier? = nil,
    restoreImageID: UUID? = nil,
    storage: [MachineStorageSpecification],
    cpuCount: Float = 1,
    memory: Float = (8 * 1_024 * 1_024 * 1_024),
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

  @available(*, deprecated)
  public init(
    libraryID: LibraryIdentifier? = nil,
    restoreImageID: UUID? = nil,
    storage: [MachineStorageSpecification]? = nil,
    cpuCount: Float = 1,
    memory: Float = (8 * 1_024 * 1_024 * 1_024),
    networkConfigurations: [NetworkConfiguration] = [.default()],
    graphicsConfigurations: [GraphicsConfiguration] = [.default()]
  ) {
    self.libraryID = libraryID
    self.restoreImageID = restoreImageID
    self.storage = storage ?? [.defaultPrimary]
    self.cpuCount = cpuCount
    self.memory = memory
    self.networkConfigurations = networkConfigurations
    self.graphicsConfigurations = graphicsConfigurations
  }
}

extension MachineSetupConfiguration {
  public var primaryStorage: MachineStorageSpecification {
    get {
      self.storage.first ?? .defaultPrimary
    }
    set {
      self.storage[0] = newValue
    }
  }

  public var primaryStorageSizeFloat: Float {
    get {
      Float(self.primaryStorage.size)
    }
    set {
      self.primaryStorage.size = .init(newValue)
    }
  }

  @available(*, deprecated, message: "Pass the MachineSystem as well.")
  public init(request: MachineBuildRequest?) {
    self.init(
      libraryID: request?.restoreImage?.libraryID,
      restoreImageID: request?.restoreImage?.imageID
    )
  }

  /// Initializes a new `MachineSetupConfiguration`
  /// with the provided `MachineBuildRequest` and `MachineSystem`.
  /// - Parameters:
  ///   - request: The `MachineBuildRequest` to use for initialization.
  ///   - system: The `MachineSystem` to use for the default storage specification.
  @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
  public init(request: MachineBuildRequest?, system: any MachineSystem) {
    self.init(
      libraryID: request?.restoreImage?.libraryID,
      restoreImageID: request?.restoreImage?.imageID,
      storage: [.default(forSystem: system)]
    )
  }

  /// Updates the `MachineSetupConfiguration` with the provided `MachineBuildRequest`.
  /// - Parameter request: The `MachineBuildRequest` to use for updating the configuration.
  public mutating func updating(forRequest request: MachineBuildRequest?) {
    self.restoreImageID = request?.restoreImage?.imageID
    self.libraryID = request?.restoreImage?.libraryID
  }
}
