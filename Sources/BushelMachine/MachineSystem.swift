//
//  MachineSystem.swift
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
public import OSVer

/// Manages a set of machines for a system
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
public protocol MachineSystem: Sendable {
  associatedtype RestoreImageType: Sendable
  /// Supported system id
  var id: VMSystemID { get }

  /// Default label for a new virtual hard drive.
  var defaultStorageLabel: String { get }

  /// Default snapshot system.
  var defaultSnapshotSystem: SnapshotterID { get }

  /// Creates a builder for creating the machine
  /// - Parameters:
  ///   - configuration: Build configuration for the machine.
  ///   - url: Destination URL for the new machine.
  /// - Returns: The MachineBuilder to use.
  @MainActor
  func createBuilder(
    for configuration: MachineBuildConfiguration<RestoreImageType>,
    at url: URL
  ) async throws -> any MachineBuilder

  func machine(
    at url: URL,
    withConfiguration configuration: MachineConfiguration
  ) async throws -> MachineRegistration

  /// Creates the necessary restore image based on the installer image info.
  /// - Parameter restoreImage: The installer image to use.
  /// - Returns: An image to use for create a machine.
  func restoreImage(from restoreImage: any InstallerImage) async throws -> RestoreImageType

  /// Returns the range of configuration values available.
  /// - Parameter restoreImage: The installer image to use.
  /// - Returns: ``ConfigurationRange`` giving the cpu count range and memory range.
  func configurationRange(for restoreImage: any InstallerImage) -> ConfigurationRange

  func operatingSystemShortName(for osVer: OSVer, buildVersion: String?) -> String
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension MachineSystem {
  /// Create a builder based on the specification.
  /// - Parameters:
  ///   - configuration: The configured specifications.
  ///   - image: Install Image.
  ///   - url: Destination URL.
  /// - Returns: Machine builder to start creating the machine.
  public func createBuilder(
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
  ///   - url: Destination URL.
  /// - Returns: Machine builder to start creating the machine.
  public func createBuilder(
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
