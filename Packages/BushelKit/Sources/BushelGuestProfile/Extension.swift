//
// Extension.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - Extension

public struct Extension: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case infoPath = "info path"
    case infoVersion = "info version"
  }

  public let infoPath: String
  public let infoVersion: String

  public init(infoPath: String, infoVersion: String) {
    self.infoPath = infoPath
    self.infoVersion = infoVersion
  }
}
