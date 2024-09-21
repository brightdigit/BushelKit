//
//  SPUSBDataTypeItem.swift
//  Sublimation
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

// MARK: - SPUSBDataTypeItem

public struct SPUSBDataTypeItem: Codable, Equatable, Sendable {
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

  public let name: String
  public let bcdDevice: String
  public let busPower: String
  public let busPowerUsed: String
  public let deviceSpeed: String
  public let extraCurrentUsed: String
  public let locationID: String
  public let manufacturer: String
  public let productID: String
  public let vendorID: String

  // swiftlint:disable:next line_length
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
