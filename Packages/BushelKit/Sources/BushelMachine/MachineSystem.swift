//
// MachineSystem.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

/// Manages a set of machines for a system
public protocol MachineSystem: Sendable {
  associatedtype RestoreImageType: Sendable
  /// Supported system id
  var id: VMSystemID { get }

  /// Default label for a new virtual hard drive.
  var defaultStorageLabel: String { get }

  /// Default snapshot system.
  var defaultSnapshotSystem: SnapshotterID { get }

  @MainActor
  /// Creates a builder for creating the machine
  /// - Parameters:
  ///   - configuration: Build configuration for the machine.
  ///   - url: Destination URL for the new machine.
  /// - Returns: The MachineBuilder to use.
  func createBuilder(
    for configuration: MachineBuildConfiguration<RestoreImageType>,
    at url: URL
  ) throws -> any MachineBuilder

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

  /// Returns the range of configuration values available.
  /// - Parameter restoreImage: The installer image to use.
  /// - Returns: ``ConfigurationRange`` giving the cpu count range and memory range.
  func configurationRange(for restoreImage: any InstallerImage) -> ConfigurationRange
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
    withDataDirectoryAt url: URL
  ) async throws -> any MachineBuilder {
    let restoreImage: RestoreImageType
    do {
      restoreImage = try await self.restoreImage(from: image)
    } catch let error as NSError {
      if let error = BuilderError.restoreImage(image, withError: error) {
        throw error
      }
      assertionFailure(error: error)
      throw error
    } catch {
      assertionFailure(error: error)
      throw error
    }
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

  /// Create a builder based on the specification.
  /// - Parameters:
  ///   - configuration: The configured specifications.
  ///   - image: Install Image.
  ///   - url: Desintation URL.
  /// - Returns: Machine builder to start creating the machine.
  func createBuilder(
    for configuration: MachineConfiguration,
    image: any InstallerImage,
    withDataDirectoryAt url: URL
  ) async throws -> any MachineBuilder {
    let restoreImage: RestoreImageType
    do {
      restoreImage = try await self.restoreImage(from: image)
    } catch let error as NSError {
      if let error = BuilderError.restoreImage(image, withError: error) {
        throw error
      }
      assertionFailure(error: error)
      throw error
    } catch {
      assertionFailure(error: error)
      throw error
    }
    let setupConfiguration = MachineBuildConfiguration(
      configuration: configuration,
      restoreImage: restoreImage
    )
    return try await self.createBuilder(for: setupConfiguration, at: url)
  }
}
