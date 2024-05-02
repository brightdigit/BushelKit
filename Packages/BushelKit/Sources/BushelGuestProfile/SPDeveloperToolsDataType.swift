//
// SPDeveloperToolsDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPDeveloperToolsDataType

public struct SPDeveloperToolsDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case spdevtoolsApps = "spdevtools_apps"
    case spdevtoolsPath = "spdevtools_path"
    case spdevtoolsSdks = "spdevtools_sdks"
    case spdevtoolsVersion = "spdevtools_version"
  }

  public let name: String
  public let spdevtoolsApps: SpdevtoolsApps
  public let spdevtoolsPath: String
  public let spdevtoolsSdks: SpdevtoolsSdks
  public let spdevtoolsVersion: String

  // swiftlint:disable:next line_length
  public init(name: String, spdevtoolsApps: SpdevtoolsApps, spdevtoolsPath: String, spdevtoolsSdks: SpdevtoolsSdks, spdevtoolsVersion: String) {
    self.name = name
    self.spdevtoolsApps = spdevtoolsApps
    self.spdevtoolsPath = spdevtoolsPath
    self.spdevtoolsSdks = spdevtoolsSdks
    self.spdevtoolsVersion = spdevtoolsVersion
  }
}
