//
// DNS.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - DNS

public struct DNS: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case domainName = "DomainName"
    case searchDomains = "SearchDomains"
    case serverAddresses = "ServerAddresses"
  }

  public let domainName: String
  public let searchDomains: [String]
  public let serverAddresses: [String]

  public init(domainName: String, searchDomains: [String], serverAddresses: [String]) {
    self.domainName = domainName
    self.searchDomains = searchDomains
    self.serverAddresses = serverAddresses
  }
}
