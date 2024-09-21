//
//  MachineSetupConfiguration.swift
//  Sublimation
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

public import BushelCore
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
  /// Netwoking Configuration
  public var networkConfigurations: [NetworkConfiguration]
  /// Graphics Configuration
  public var graphicsConfigurations: [GraphicsConfiguration]

  public var snapshotSystemID: SnapshotterID = .fileVersion

  public init(system: any MachineSystem) { self.init(storage: [.default(forSystem: system)]) }

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

  @available(*, deprecated) public init(
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
    get { storage.first ?? .defaultPrimary }
    set { storage[0] = newValue }
  }

  public var primaryStorageSizeFloat: Float {
    get { Float(primaryStorage.size) }
    set { primaryStorage.size = .init(newValue) }
  }

  @available(*, deprecated, message: "Pass the MachineSystem as well.") public init(
    request: MachineBuildRequest?
  ) {
    self.init(
      libraryID: request?.restoreImage?.libraryID,
      restoreImageID: request?.restoreImage?.imageID
    )
  }

  public init(request: MachineBuildRequest?, system: any MachineSystem) {
    self.init(
      libraryID: request?.restoreImage?.libraryID,
      restoreImageID: request?.restoreImage?.imageID,
      storage: [.default(forSystem: system)]
    )
  }

  public mutating func updating(forRequest request: MachineBuildRequest?) {
    restoreImageID = request?.restoreImage?.imageID
    libraryID = request?.restoreImage?.libraryID
  }
}
