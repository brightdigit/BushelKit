//
//  SPBluetoothDataType.swift
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

/// Represents a Bluetooth data type.
public struct SPBluetoothDataType: Codable, Equatable, Sendable {
  /// The coding keys for the Bluetooth data type.
  public enum CodingKeys: String, CodingKey {
    case controllerProperties = "controller_properties"
  }

  /// The controller properties associated with the Bluetooth data type.
  public let controllerProperties: ControllerProperties

  /// Initializes a new instance of `SPBluetoothDataType` with the specified controller properties.
  /// - Parameter controllerProperties:
  /// The controller properties to be associated with the Bluetooth data type.
  public init(controllerProperties: ControllerProperties) {
    self.controllerProperties = controllerProperties
  }
}
