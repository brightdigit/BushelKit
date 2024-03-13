//
// SpnetworklocationService.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SpnetworklocationService

public struct SpnetworklocationService: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case bsdDeviceName = "bsd_device_name"
    case hardwareAddress = "hardware_address"
    case iPv4 = "IPv4"
    case iPv6 = "IPv6"
    case proxies = "Proxies"
    case type
  }

  public let name: String
  public let bsdDeviceName: String
  public let hardwareAddress: String
  public let iPv4: IPV
  public let iPv6: IPV
  public let proxies: Proxies
  public let type: String

  // swiftlint:disable:next line_length
  public init(name: String, bsdDeviceName: String, hardwareAddress: String, iPv4: IPV, iPv6: IPV, proxies: Proxies, type: String) {
    self.name = name
    self.bsdDeviceName = bsdDeviceName
    self.hardwareAddress = hardwareAddress
    self.iPv4 = iPv4
    self.iPv6 = iPv6
    self.proxies = proxies
    self.type = type
  }
}
