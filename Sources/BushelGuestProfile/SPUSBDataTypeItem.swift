//
//  SPUSBDataTypeItem.swift
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

/// Represents a USB device data type item.
public struct SPUSBDataTypeItem: Codable, Equatable, Sendable {
  /// Coding keys for the USB device data type item.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case bcdDevice = "bcd_device"
    case busPower = "bus_power"
    case busPowerUsed = "bus_power_used"
    case deviceSpeed = "device_speed"
    case extraCurrentUsed = "extra_current_used"
    case locationID = "location_id"
    case manufacturer
    case productID = "product_id"
    case vendorID = "vendor_id"
  }

  /// The name of the USB device.
  public let name: String

  /// The USB device code.
  public let bcdDevice: String

  /// The bus power of the USB device.
  public let busPower: String

  /// The bus power used by the USB device.
  public let busPowerUsed: String

  /// The speed of the USB device.
  public let deviceSpeed: String

  /// The extra current used by the USB device.
  public let extraCurrentUsed: String

  /// The location ID of the USB device.
  public let locationID: String

  /// The manufacturer of the USB device.
  public let manufacturer: String

  /// The product ID of the USB device.
  public let productID: String

  /// The vendor ID of the USB device.
  public let vendorID: String

  /// Initializes a new instance of `SPUSBDataTypeItem` with the provided parameters.
  ///
  /// - Parameters:
  ///   - name: The name of the USB device.
  ///   - bcdDevice: The USB device code.
  ///   - busPower: The bus power of the USB device.
  ///   - busPowerUsed: The bus power used by the USB device.
  ///   - deviceSpeed: The speed of the USB device.
  ///   - extraCurrentUsed: The extra current used by the USB device.
  ///   - locationID: The location ID of the USB device.
  ///   - manufacturer: The manufacturer of the USB device.
  ///   - productID: The product ID of the USB device.
  ///   - vendorID: The vendor ID of the USB device.
  public init(
    name: String,
    bcdDevice: String,
    busPower: String,
    busPowerUsed: String,
    deviceSpeed: String,
    extraCurrentUsed: String,
    locationID: String,
    manufacturer: String,
    productID: String,
    vendorID: String
  ) {
    self.name = name
    self.bcdDevice = bcdDevice
    self.busPower = busPower
    self.busPowerUsed = busPowerUsed
    self.deviceSpeed = deviceSpeed
    self.extraCurrentUsed = extraCurrentUsed
    self.locationID = locationID
    self.manufacturer = manufacturer
    self.productID = productID
    self.vendorID = vendorID
  }
}
