//
//  ControllerProperties.swift
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

// MARK: - ControllerProperties

public struct ControllerProperties: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
    case controllerAddress = "controller_address"
    case controllerChipset = "controller_chipset"
    case controllerDiscoverable = "controller_discoverable"
    case controllerFirmwareVersion = "controller_firmwareVersion"
    case controllerProductID = "controller_productID"
    case controllerState = "controller_state"
    case controllerSupportedServices = "controller_supportedServices"
    case controllerTransport = "controller_transport"
    case controllerVendorID = "controller_vendorID"
  }

  public let controllerAddress: String
  public let controllerChipset: String
  public let controllerDiscoverable: String
  public let controllerFirmwareVersion: String
  public let controllerProductID: String
  public let controllerState: String
  public let controllerSupportedServices: String
  public let controllerTransport: String
  public let controllerVendorID: String

  public init(
    controllerAddress: String,
    controllerChipset: String,
    controllerDiscoverable: String,
    controllerFirmwareVersion: String,
    controllerProductID: String,
    controllerState: String,
    controllerSupportedServices: String,
    controllerTransport: String,
    controllerVendorID: String
  ) {
    self.controllerAddress = controllerAddress
    self.controllerChipset = controllerChipset
    self.controllerDiscoverable = controllerDiscoverable
    self.controllerFirmwareVersion = controllerFirmwareVersion
    self.controllerProductID = controllerProductID
    self.controllerState = controllerState
    self.controllerSupportedServices = controllerSupportedServices
    self.controllerTransport = controllerTransport
    self.controllerVendorID = controllerVendorID
  }
}
