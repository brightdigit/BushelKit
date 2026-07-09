//
//  MachineSystemStub.swift
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
public import BushelFoundationWax
public import BushelMachine
public import Foundation
public import OSVer

/// A stub `MachineSystem` implementation for tests, returning fixed stub values.
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
public struct MachineSystemStub: MachineSystem, Equatable {
  /// The restore image type produced by this system, a stub implementation.
  public typealias RestoreImageType = RestoreImageStub

  /// The default storage label used for machines created by this stub.
  public let defaultStorageLabel: String = "stub"

  /// The identifier of the default snapshot system used by this stub.
  public let defaultSnapshotSystem: SnapshotterID = "testing"

  /// The identifier of this virtual machine system.
  public var id: VMSystemID

  /// Creates a stub machine builder for the given configuration.
  ///
  /// - Parameters:
  ///   - configuration: The build configuration (ignored by this stub).
  ///   - url: The destination URL passed to the created builder.
  /// - Returns: A ``MachineBuilderStub`` targeting `url`.
  /// - Throws: This stub does not throw.
  public func createBuilder(
    for _: MachineBuildConfiguration<RestoreImageType>,
    at url: URL
  ) throws -> any MachineBuilder {
    MachineBuilderStub(url: url)
  }

  /// Returns a registration for a stub machine at the given URL.
  ///
  /// - Parameters:
  ///   - url: The location of the machine (unused beyond registration).
  ///   - configuration: The configuration used to construct the stub machine.
  /// - Returns: A registration wrapping a ``MachineStub`` in the starting state.
  /// - Throws: This stub does not throw.
  public func machine(at url: URL, withConfiguration configuration: MachineConfiguration)
    async throws -> MachineRegistration
  {
    MachineRegistrationObject(
      machine: MachineStub(configuration: configuration, state: .starting)
    ).register(_:_:)
  }

  /// Returns a stub restore image for the given installer image.
  ///
  /// - Parameter installerImage: The source installer image (ignored by this stub).
  /// - Returns: A newly created stub restore image.
  /// - Throws: This stub does not throw.
  public func restoreImage(from _: any InstallerImage) async throws -> RestoreImageType {
    .init()
  }

  /// Returns the configuration range supported for the given installer image.
  ///
  /// - Parameter installerImage: The installer image (ignored by this stub).
  /// - Returns: The default configuration range.
  public func configurationRange(for _: any InstallerImage) -> ConfigurationRange {
    .default
  }

  /// Returns a short display name for the given operating system version.
  ///
  /// - Parameters:
  ///   - osVer: The operating system version.
  ///   - buildVersion: An optional build version to append.
  /// - Returns: The version description, optionally followed by the build version.
  public func operatingSystemShortName(for osVer: OSVer, buildVersion: String?) -> String {
    [osVer.description, buildVersion].compactMap { $0 }.joined(separator: " ")
  }
}
