//
//  SPNetworkDataType.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

import Foundation

// MARK: - SPNetworkDataType

public struct SPNetworkDataType: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case dhcp
    case dns = "DNS"
    case ethernet = "Ethernet"
    case hardware
    case interface
    case ipAddress = "ip_address"
    case iPv4 = "IPv4"
    case iPv6 = "IPv6"
    case proxies = "Proxies"
    case spnetworkServiceOrder = "spnetwork_service_order"
    case type
  }

  public let name: String
  public let dhcp: DHCP?
  public let dns: DNS?
  public let ethernet: Ethernet?
  public let hardware: String
  public let interface: String
  public let ipAddress: [String]?
  public let iPv4: IPv4
  public let iPv6: IPv6
  public let proxies: Proxies
  public let spnetworkServiceOrder: Int
  public let type: String

  // swiftlint:disable:next line_length
  public init(name: String, dhcp: DHCP?, dns: DNS?, ethernet: Ethernet, hardware: String, interface: String, ipAddress: [String]?, iPv4: IPv4, iPv6: IPv6, proxies: Proxies, spnetworkServiceOrder: Int, type: String) {
    self.name = name
    self.dhcp = dhcp
    self.dns = dns
    self.ethernet = ethernet
    self.hardware = hardware
    self.interface = interface
    self.ipAddress = ipAddress
    self.iPv4 = iPv4
    self.iPv6 = iPv6
    self.proxies = proxies
    self.spnetworkServiceOrder = spnetworkServiceOrder
    self.type = type
  }
}
