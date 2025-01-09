//
//  SPEthernetDataType.swift
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

/// Represents a data structure for SPEthernetDataType.
public struct SPEthernetDataType: Codable, Equatable, Sendable {
  /// Coding keys for the SPEthernetDataType struct.
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

  /// The name of the SPEthernet device.
  public let name: String
  /// The AVB support of the SPEthernet device.
  public let spethernetAvbSupport: String
  /// The BSD device name of the SPEthernet device.
  public let spethernetBSDDeviceName: String
  /// The bus of the SPEthernet device.
  public let spethernetBus: String
  /// The device ID of the SPEthernet device.
  public let spethernetDeviceID: String
  /// The driver of the SPEthernet device.
  public let spethernetDriver: String
  /// The MAC address of the SPEthernet device.
  public let spethernetMACAddress: String
  /// The maximum link speed of the SPEthernet device.
  public let spethernetMaxLinkSpeed: String
  /// The revision ID of the SPEthernet device.
  public let spethernetRevisionID: String
  /// The subsystem ID of the SPEthernet device.
  public let spethernetSubsystemID: String
  /// The subsystem vendor ID of the SPEthernet device.
  public let spethernetSubsystemVendorID: String
  /// The vendor ID of the SPEthernet device.
  public let spethernetVendorID: String

  /// Initializes an SPEthernetDataType instance with the provided parameters.
  /// - Parameters:
  ///   - name: The name of the SPEthernet device.
  ///   - spethernetAvbSupport: The AVB support of the SPEthernet device.
  ///   - spethernetBSDDeviceName: The BSD device name of the SPEthernet device.
  ///   - spethernetBus: The bus of the SPEthernet device.
  ///   - spethernetDeviceID: The device ID of the SPEthernet device.
  ///   - spethernetDriver: The driver of the SPEthernet device.
  ///   - spethernetMACAddress: The MAC address of the SPEthernet device.
  ///   - spethernetMaxLinkSpeed: The maximum link speed of the SPEthernet device.
  ///   - spethernetRevisionID: The revision ID of the SPEthernet device.
  ///   - spethernetSubsystemID: The subsystem ID of the SPEthernet device.
  ///   - spethernetSubsystemVendorID: The subsystem vendor ID of the SPEthernet device.
  ///   - spethernetVendorID: The vendor ID of the SPEthernet device.
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
