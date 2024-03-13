//
// SPUSBDataTypeItem.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPUSBDataTypeItem

public struct SPUSBDataTypeItem: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
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
  public init(name: String, bcdDevice: String, busPower: String, busPowerUsed: String, deviceSpeed: String, extraCurrentUsed: String, locationID: String, manufacturer: String, productID: String, vendorID: String) {
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
