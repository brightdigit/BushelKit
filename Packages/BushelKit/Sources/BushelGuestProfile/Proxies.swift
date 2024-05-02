//
// Proxies.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - Proxies

public struct Proxies: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case exceptionsList = "ExceptionsList"
    case ftpPassive = "FTPPassive"
  }

  public let exceptionsList: [String]
  public let ftpPassive: PrivateFramework

  public init(exceptionsList: [String], ftpPassive: PrivateFramework) {
    self.exceptionsList = exceptionsList
    self.ftpPassive = ftpPassive
  }
}
