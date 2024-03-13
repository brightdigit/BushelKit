//
// SPEthernetDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPEthernetDataType

public struct SPEthernetDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case spethernetAvbSupport = "spethernet_avb_support"
    case spethernetBSDDeviceName = "spethernet_BSD_Device_Name"
    case spethernetBus = "spethernet_bus"
    case spethernetDeviceID = "spethernet_device-id"
    case spethernetDriver = "spethernet_driver"
    case spethernetMACAddress = "spethernet_mac_address"
    case spethernetMaxLinkSpeed = "spethernet_max_link_speed"
    case spethernetRevisionID = "spethernet_revision-id"
    case spethernetSubsystemID = "spethernet_subsystem-id"
    case spethernetSubsystemVendorID = "spethernet_subsystem-vendor-id"
    case spethernetVendorID = "spethernet_vendor-id"
  }

  public let name: String
  public let spethernetAvbSupport: String
  public let spethernetBSDDeviceName: String
  public let spethernetBus: String
  public let spethernetDeviceID: String
  public let spethernetDriver: String
  public let spethernetMACAddress: String
  public let spethernetMaxLinkSpeed: String
  public let spethernetRevisionID: String
  public let spethernetSubsystemID: String
  public let spethernetSubsystemVendorID: String
  public let spethernetVendorID: String

  // swiftlint:disable:next line_length
  public init(name: String, spethernetAvbSupport: String, spethernetBSDDeviceName: String, spethernetBus: String, spethernetDeviceID: String, spethernetDriver: String, spethernetMACAddress: String, spethernetMaxLinkSpeed: String, spethernetRevisionID: String, spethernetSubsystemID: String, spethernetSubsystemVendorID: String, spethernetVendorID: String) {
    self.name = name
    self.spethernetAvbSupport = spethernetAvbSupport
    self.spethernetBSDDeviceName = spethernetBSDDeviceName
    self.spethernetBus = spethernetBus
    self.spethernetDeviceID = spethernetDeviceID
    self.spethernetDriver = spethernetDriver
    self.spethernetMACAddress = spethernetMACAddress
    self.spethernetMaxLinkSpeed = spethernetMaxLinkSpeed
    self.spethernetRevisionID = spethernetRevisionID
    self.spethernetSubsystemID = spethernetSubsystemID
    self.spethernetSubsystemVendorID = spethernetSubsystemVendorID
    self.spethernetVendorID = spethernetVendorID
  }
}
