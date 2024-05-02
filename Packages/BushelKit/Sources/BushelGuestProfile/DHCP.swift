//
// DHCP.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - DHCP

public struct DHCP: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case dhcpDomainName = "dhcp_domain_name"
    case dhcpDomainNameServers = "dhcp_domain_name_servers"
    case dhcpLeaseDuration = "dhcp_lease_duration"
    case dhcpMessageType = "dhcp_message_type"
    case dhcpRouters = "dhcp_routers"
    case dhcpServerIdentifier = "dhcp_server_identifier"
    case dhcpSubnetMask = "dhcp_subnet_mask"
  }

  public let dhcpDomainName: String
  public let dhcpDomainNameServers: String
  public let dhcpLeaseDuration: Int
  public let dhcpMessageType: String
  public let dhcpRouters: String
  public let dhcpServerIdentifier: String
  public let dhcpSubnetMask: String

  public init(
    dhcpDomainName: String,
    dhcpDomainNameServers: String,
    dhcpLeaseDuration: Int,
    dhcpMessageType: String,
    dhcpRouters: String,
    dhcpServerIdentifier: String,
    dhcpSubnetMask: String
  ) {
    self.dhcpDomainName = dhcpDomainName
    self.dhcpDomainNameServers = dhcpDomainNameServers
    self.dhcpLeaseDuration = dhcpLeaseDuration
    self.dhcpMessageType = dhcpMessageType
    self.dhcpRouters = dhcpRouters
    self.dhcpServerIdentifier = dhcpServerIdentifier
    self.dhcpSubnetMask = dhcpSubnetMask
  }
}
