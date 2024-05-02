//
// Ethernet.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - Ethernet

public struct Ethernet: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case macAddress = "MAC Address"
    case mediaOptions = "MediaOptions"
    case mediaSubType = "MediaSubType"
  }

  public let macAddress: String
  public let mediaOptions: [String]
  public let mediaSubType: String

  public init(macAddress: String, mediaOptions: [String], mediaSubType: String) {
    self.macAddress = macAddress
    self.mediaOptions = mediaOptions
    self.mediaSubType = mediaSubType
  }
}
