//
//  SPNetworkLocationDataType.swift
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

/// A struct representing a network location data type.
public struct SPNetworkLocationDataType: Codable, Equatable, Sendable {
  /// The keys used for encoding and decoding the struct.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case spnetworklocationIsActive = "spnetworklocation_isActive"
    case spnetworklocationServices = "spnetworklocation_services"
  }

  /// The name of the network location data type.
  public let name: String
  /// The active status of the network location.
  public let spnetworklocationIsActive: PrivateFramework
  /// The list of services associated with the network location.
  public let spnetworklocationServices: [SpnetworklocationService]

  /// Initializes a new instance of `SPNetworkLocationDataType`.
  /// - Parameters:
  ///   - name: The name of the network location data type.
  ///   - spnetworklocationIsActive: The active status of the network location.
  ///   - spnetworklocationServices: The list of services associated with the network location.
  public init(
    name: String,
    spnetworklocationIsActive: PrivateFramework,
    spnetworklocationServices: [SpnetworklocationService]
  ) {
    self.name = name
    self.spnetworklocationIsActive = spnetworklocationIsActive
    self.spnetworklocationServices = spnetworklocationServices
  }
}
