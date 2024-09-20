//
//  SPEthernetDataType.swift
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

public import Foundation

// MARK: - SPEthernetDataType

public struct SPEthernetDataType: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
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

  public init(
    name: String,
    spethernetAvbSupport: String,
    spethernetBSDDeviceName: String,
    spethernetBus: String,
    spethernetDeviceID: String,
    spethernetDriver: String,
    spethernetMACAddress: String,
    spethernetMaxLinkSpeed: String,
    spethernetRevisionID: String,
    spethernetSubsystemID: String,
    spethernetSubsystemVendorID: String,
    spethernetVendorID: String
  ) {
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
