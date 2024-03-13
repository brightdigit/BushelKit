//
// SPNetworkDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPNetworkDataType

public struct SPNetworkDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
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
