//
//  DHCP.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

public import Foundation

/// Represents a DHCP (Dynamic Host Configuration Protocol) response.
public struct DHCP: Codable, Equatable, Sendable {
  /// Coding keys for DHCP.
  public enum CodingKeys: String, CodingKey {
    case dhcpDomainName = "dhcp_domain_name"
    case dhcpDomainNameServers = "dhcp_domain_name_servers"
    case dhcpLeaseDuration = "dhcp_lease_duration"
    case dhcpMessageType = "dhcp_message_type"
    case dhcpRouters = "dhcp_routers"
    case dhcpServerIdentifier = "dhcp_server_identifier"
    case dhcpSubnetMask = "dhcp_subnet_mask"
  }

  /// The domain name provided by the DHCP server.
  public let dhcpDomainName: String
  /// The domain name servers provided by the DHCP server.
  public let dhcpDomainNameServers: String
  /// The lease duration (in seconds) provided by the DHCP server.
  public let dhcpLeaseDuration: Int
  /// The DHCP message type provided by the DHCP server.
  public let dhcpMessageType: String
  /// The routers provided by the DHCP server.
  public let dhcpRouters: String
  /// The DHCP server identifier.
  public let dhcpServerIdentifier: String
  /// The subnet mask provided by the DHCP server.
  public let dhcpSubnetMask: String

  /// Initializes a `DHCP` instance with the provided parameters.
  ///
  /// - Parameters:
  ///   - dhcpDomainName: The domain name provided by the DHCP server.
  ///   - dhcpDomainNameServers: The domain name servers provided by the DHCP server.
  ///   - dhcpLeaseDuration: The lease duration (in seconds) provided by the DHCP server.
  ///   - dhcpMessageType: The DHCP message type provided by the DHCP server.
  ///   - dhcpRouters: The routers provided by the DHCP server.
  ///   - dhcpServerIdentifier: The DHCP server identifier.
  ///   - dhcpSubnetMask: The subnet mask provided by the DHCP server.
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
