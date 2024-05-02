//
// ControllerProperties.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - ControllerProperties

public struct ControllerProperties: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
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
