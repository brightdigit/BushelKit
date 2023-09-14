//
// MachineSystem.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public protocol MachineSystem {
  associatedtype RestoreImageType
  var id: VMSystemID { get }
  @MainActor
  func createBuilder(
    for configuration: MachineBuildConfiguration<RestoreImageType>,
    at url: URL
  ) throws -> MachineBuilder
  func restoreImage(from restoreImage: any InstallerImage) async throws -> RestoreImageType
  func machine(at url: URL, withConfiguration configuration: MachineConfiguration) throws -> any Machine
}

public extension MachineSystem {
  func createBuilder(
    for configuration: MachineSetupConfiguration,
    image: any InstallerImage,
    at url: URL
  ) async throws -> MachineBuilder {
    let restoreImage = try await self.restoreImage(from: image)
    let machineConfiguration = MachineConfiguration(setup: configuration, restoreImageFile: image)
    let setupConfiguration = MachineBuildConfiguration(
      configuration: machineConfiguration,
      restoreImage: restoreImage
    )
    return try await self.createBuilder(for: setupConfiguration, at: url)
  }
}
