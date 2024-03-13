//
// SPSyncServicesDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPSyncServicesDataType

public struct SPSyncServicesDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case items = "_items"
    case name = "_name"
    case summaryOSVersion = "summary_os_version"
  }

  public let items: [SPSyncServicesDataTypeItem]
  public let name: String
  public let summaryOSVersion: String?

  public init(items: [SPSyncServicesDataTypeItem], name: String, summaryOSVersion: String?) {
    self.items = items
    self.name = name
    self.summaryOSVersion = summaryOSVersion
  }
}
