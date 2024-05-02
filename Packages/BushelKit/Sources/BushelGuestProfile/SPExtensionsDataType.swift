//
// SPExtensionsDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPExtensionsDataType

public struct SPExtensionsDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
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

  public let name: String
  public let spextArchitectures: [SpextArchitecture]?
  public let spextBundleid: String
  public let spextHas64BitIntelCode: Spext?
  public let spextHasAllDependencies: SpextHasAllDependencies
  public let spextLastModified: Date
  public let spextLoadable: Spext
  public let spextLoaded: Spext
  public let spextNotarized: Spext
  public let spextObtainedFrom: SpextObtainedFrom
  public let spextPath: String
  public let spextRuntimeEnvironment: SpextRuntimeEnvironment?
  public let spextSignedBy: String
  public let spextVersion: String
  public let version: String
  public let spextValidErrors: SpextValidErrors?
  public let spextInfo: String?
  public let spextLoadAddress: String?
  public let spextHasAllDependenciesErrors: SpextHasAllDependenciesErrors?

  // swiftlint:disable:next line_length
  public init(name: String, spextArchitectures: [SpextArchitecture]?, spextBundleid: String, spextHas64BitIntelCode: Spext?, spextHasAllDependencies: SpextHasAllDependencies, spextLastModified: Date, spextLoadable: Spext, spextLoaded: Spext, spextNotarized: Spext, spextObtainedFrom: SpextObtainedFrom, spextPath: String, spextRuntimeEnvironment: SpextRuntimeEnvironment?, spextSignedBy: String, spextVersion: String, version: String, spextValidErrors: SpextValidErrors?, spextInfo: String?, spextLoadAddress: String?, spextHasAllDependenciesErrors: SpextHasAllDependenciesErrors?) {
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
