//
//  SPExtensionsDataType.swift
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

public import Foundation

/// Represents the data type for SPExtensions.
public struct SPExtensionsDataType: Codable, Equatable, Sendable {
  /// The coding keys used for encoding and decoding the `SPExtensionsDataType` struct.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case spextArchitectures = "spext_architectures"
    case spextBundleid = "spext_bundleid"
    case spextHas64BitIntelCode = "spext_has64BitIntelCode"
    case spextHasAllDependencies = "spext_hasAllDependencies"
    case spextLastModified = "spext_lastModified"
    case spextLoadable = "spext_loadable"
    case spextLoaded = "spext_loaded"
    case spextNotarized = "spext_notarized"
    case spextObtainedFrom = "spext_obtained_from"
    case spextPath = "spext_path"
    case spextRuntimeEnvironment = "spext_runtime_environment"
    case spextSignedBy = "spext_signed_by"
    case spextVersion = "spext_version"
    case version
    case spextValidErrors = "spext_valid_errors"
    case spextInfo = "spext_info"
    case spextLoadAddress = "spext_load_address"
    case spextHasAllDependenciesErrors = "spext_hasAllDependencies_errors"
  }

  /// The name of the SPExtension.
  public let name: String
  /// The architectures of the SPExtension.
  public let spextArchitectures: [SpextArchitecture]?
  /// The bundle identifier of the SPExtension.
  public let spextBundleid: String
  /// Indicates if the SPExtension has 64-bit Intel code.
  public let spextHas64BitIntelCode: Spext?
  /// Indicates if the SPExtension has all dependencies.
  public let spextHasAllDependencies: SpextHasAllDependencies
  /// The last modification date of the SPExtension.
  public let spextLastModified: Date
  /// Indicates if the SPExtension is loadable.
  public let spextLoadable: Spext
  /// Indicates if the SPExtension is loaded.
  public let spextLoaded: Spext
  /// Indicates if the SPExtension is notarized.
  public let spextNotarized: Spext
  /// The source from which the SPExtension was obtained.
  public let spextObtainedFrom: SpextObtainedFrom
  /// The file path of the SPExtension.
  public let spextPath: String
  /// The runtime environment of the SPExtension.
  public let spextRuntimeEnvironment: SpextRuntimeEnvironment?
  /// The entity that signed the SPExtension.
  public let spextSignedBy: String
  /// The version of the SPExtension.
  public let spextVersion: String
  /// The version of the SPExtension.
  public let version: String
  /// The valid errors of the SPExtension.
  public let spextValidErrors: SpextValidErrors?
  /// Additional information about the SPExtension.
  public let spextInfo: String?
  /// The load address of the SPExtension.
  public let spextLoadAddress: String?
  /// The errors related to the SPExtension having all dependencies.
  public let spextHasAllDependenciesErrors: SpextHasAllDependenciesErrors?

  /// Initializes an `SPExtensionsDataType` instance with the provided parameters.
  /// - Parameters:
  ///   - name: The name of the SPExtension.
  ///   - spextArchitectures: The architectures of the SPExtension.
  ///   - spextBundleid: The bundle identifier of the SPExtension.
  ///   - spextHas64BitIntelCode: Indicates if the SPExtension has 64-bit Intel code.
  ///   - spextHasAllDependencies: Indicates if the SPExtension has all dependencies.
  ///   - spextLastModified: The last modification date of the SPExtension.
  ///   - spextLoadable: Indicates if the SPExtension is loadable.
  ///   - spextLoaded: Indicates if the SPExtension is loaded.
  ///   - spextNotarized: Indicates if the SPExtension is notarized.
  ///   - spextObtainedFrom: The source from which the SPExtension was obtained.
  ///   - spextPath: The file path of the SPExtension.
  ///   - spextRuntimeEnvironment: The runtime environment of the SPExtension.
  ///   - spextSignedBy: The entity that signed the SPExtension.
  ///   - spextVersion: The version of the SPExtension.
  ///   - version: The version of the SPExtension.
  ///   - spextValidErrors: The valid errors of the SPExtension.
  ///   - spextInfo: Additional information about the SPExtension.
  ///   - spextLoadAddress: The load address of the SPExtension.
  ///   - spextHasAllDependenciesErrors: The errors related to the SPExtension having all dependencies.
  public init(
    name: String,
    spextArchitectures: [SpextArchitecture]?,
    spextBundleid: String,
    spextHas64BitIntelCode: Spext?,
    spextHasAllDependencies: SpextHasAllDependencies,
    spextLastModified: Date,
    spextLoadable: Spext,
    spextLoaded: Spext,
    spextNotarized: Spext,
    spextObtainedFrom: SpextObtainedFrom,
    spextPath: String,
    spextRuntimeEnvironment: SpextRuntimeEnvironment?,
    spextSignedBy: String,
    spextVersion: String,
    version: String,
    spextValidErrors: SpextValidErrors?,
    spextInfo: String?,
    spextLoadAddress: String?,
    spextHasAllDependenciesErrors: SpextHasAllDependenciesErrors?
  ) {
    self.name = name
    self.spextArchitectures = spextArchitectures
    self.spextBundleid = spextBundleid
    self.spextHas64BitIntelCode = spextHas64BitIntelCode
    self.spextHasAllDependencies = spextHasAllDependencies
    self.spextLastModified = spextLastModified
    self.spextLoadable = spextLoadable
    self.spextLoaded = spextLoaded
    self.spextNotarized = spextNotarized
    self.spextObtainedFrom = spextObtainedFrom
    self.spextPath = spextPath
    self.spextRuntimeEnvironment = spextRuntimeEnvironment
    self.spextSignedBy = spextSignedBy
    self.spextVersion = spextVersion
    self.version = version
    self.spextValidErrors = spextValidErrors
    self.spextInfo = spextInfo
    self.spextLoadAddress = spextLoadAddress
    self.spextHasAllDependenciesErrors = spextHasAllDependenciesErrors
  }
}
