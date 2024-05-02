//
// SPFirewallDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPFirewallDataType

public struct SPFirewallDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case spfirewallGlobalstate = "spfirewall_globalstate"
    case spfirewallLoggingenabled = "spfirewall_loggingenabled"
    case spfirewallStealthenabled = "spfirewall_stealthenabled"
  }

  public let name: String
  public let spfirewallGlobalstate: String
  public let spfirewallLoggingenabled: String
  public let spfirewallStealthenabled: String

  // swiftlint:disable:next line_length
  public init(name: String, spfirewallGlobalstate: String, spfirewallLoggingenabled: String, spfirewallStealthenabled: String) {
    self.name = name
    self.spfirewallGlobalstate = spfirewallGlobalstate
    self.spfirewallLoggingenabled = spfirewallLoggingenabled
    self.spfirewallStealthenabled = spfirewallStealthenabled
  }
}
