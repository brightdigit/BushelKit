//
// SPInstallHistoryDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPInstallHistoryDataType

public struct SPInstallHistoryDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case installDate = "install_date"
    case installVersion = "install_version"
    case packageSource = "package_source"
  }

  public let name: String
  public let installDate: Date
  public let installVersion: String
  public let packageSource: PackageSource

  public init(name: String, installDate: Date, installVersion: String, packageSource: PackageSource) {
    self.name = name
    self.installDate = installDate
    self.installVersion = installVersion
    self.packageSource = packageSource
  }
}
