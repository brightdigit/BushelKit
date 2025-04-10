//
//  ControllerProperties.swift
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

internal import Foundation

/// A struct that represents the properties of a controller.
public struct ControllerProperties: Codable, Equatable, Sendable {
  /// The coding keys for the properties of the controller.
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

  /// The address of the controller.
  public let controllerAddress: String

  /// The chipset of the controller.
  public let controllerChipset: String

  /// The discoverability state of the controller.
  public let controllerDiscoverable: String

  /// The firmware version of the controller.
  public let controllerFirmwareVersion: String

  /// The product ID of the controller.
  public let controllerProductID: String

  /// The state of the controller.
  public let controllerState: String

  /// The supported services of the controller.
  public let controllerSupportedServices: String

  /// The transport of the controller.
  public let controllerTransport: String

  /// The vendor ID of the controller.
  public let controllerVendorID: String

  /// Initializes a new instance of `ControllerProperties` with the specified properties.
  ///
  /// - Parameters:
  ///   - controllerAddress: The address of the controller.
  ///   - controllerChipset: The chipset of the controller.
  ///   - controllerDiscoverable: The discoverability state of the controller.
  ///   - controllerFirmwareVersion: The firmware version of the controller.
  ///   - controllerProductID: The product ID of the controller.
  ///   - controllerState: The state of the controller.
  ///   - controllerSupportedServices: The supported services of the controller.
  ///   - controllerTransport: The transport of the controller.
  ///   - controllerVendorID: The vendor ID of the controller.
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
