//
// SPLogsDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPLogsDataType

public struct SPLogsDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case byteSize
    case contents
    case lastModified
    case source
  }

  public let name: String
  public let byteSize: Int
  public let contents: String
  public let lastModified: Date?
  public let source: String

  public init(name: String, byteSize: Int, contents: String, lastModified: Date?, source: String) {
    self.name = name
    self.byteSize = byteSize
    self.contents = contents
    self.lastModified = lastModified
    self.source = source
  }
}
