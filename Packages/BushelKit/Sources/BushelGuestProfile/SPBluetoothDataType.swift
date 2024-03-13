//
// SPBluetoothDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPBluetoothDataType

public struct SPBluetoothDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case controllerProperties = "controller_properties"
  }

  public let controllerProperties: ControllerProperties

  public init(controllerProperties: ControllerProperties) {
    self.controllerProperties = controllerProperties
  }
}
