//
// MachineSystem.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

/// Manages a set of machines for a system
public protocol MachineSystem {
  associatedtype RestoreImageType
  /// Supported system id
  var id: VMSystemID { get }

  @MainActor
  /// Creates a builder for creating the machine
  /// - Parameters:
  ///   - configuration: Build configuration for the machine.
  ///   - url: Destination URL for the new machine.
  /// - Returns: The MachineBuilder to use.
  func createBuilder(
    for configuration: MachineBuildConfiguration<RestoreImageType>,
    at url: URL
  ) throws -> MachineBuilder

  /// Creates a machine based on the url and configuration.
  /// - Parameters:
  ///   - url: URL of the machine bundle.
  ///   - configuration: The machine configuration.
  /// - Returns: A usable machine.
  func machine(
    at url: URL,
    withConfiguration configuration: MachineConfiguration
  ) async throws -> any Machine

  /// Creates the nessecary restore image based on the installer image info.
  /// - Parameter restoreImage: The installer image to use.
  /// - Returns: An image to use for create a machine.
  func restoreImage(from restoreImage: any InstallerImage) async throws -> RestoreImageType
}

public extension MachineSystem {
  /// Create a builder based on the specification.
  /// - Parameters:
  ///   - configuration: The configured specifications.
  ///   - image: Install Image.
  ///   - url: Desintation URL.
  /// - Returns: Machine builder to start creating the machine.
  func createBuilder(
    for configuration: MachineSetupConfiguration,
    image: any InstallerImage,
    at url: URL
  ) async throws -> MachineBuilder {
    let restoreImage = try await self.restoreImage(from: image)
    let machineConfiguration = MachineConfiguration(
      setup: configuration,
      restoreImageFile: image
    )
    let setupConfiguration = MachineBuildConfiguration(
      configuration: machineConfiguration,
      restoreImage: restoreImage
    )
    return try await self.createBuilder(for: setupConfiguration, at: url)
  }
}
