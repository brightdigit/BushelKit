//
// SPSyncServicesDataTypeItem.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPSyncServicesDataTypeItem

public struct SPSyncServicesDataTypeItem: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case summaryOfSyncLog = "summary_of_sync_log"
    case contents
    case description
    case lastModified
    case size
  }

  public let name: String
  public let summaryOfSyncLog: String?
  public let contents: String?
  public let description: String?
  public let lastModified: Date?
  public let size: String?

  // swiftlint:disable:next line_length
  public init(name: String, summaryOfSyncLog: String?, contents: String?, description: String?, lastModified: Date?, size: String?) {
    self.name = name
    self.summaryOfSyncLog = summaryOfSyncLog
    self.contents = contents
    self.description = description
    self.lastModified = lastModified
    self.size = size
  }
}
