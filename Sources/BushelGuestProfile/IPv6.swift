//
//  IPv6.swift
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

// MARK: - IPv6

/// Represents an IPv6 configuration.
public struct IPv6: Codable, Equatable, Sendable {
  /// The keys used to encode and decode the IPv6 configuration.
  public enum CodingKeys: String, CodingKey {
    case addresses = "Addresses"
    case configMethod = "ConfigMethod"
    case confirmedInterfaceName = "ConfirmedInterfaceName"
    case interfaceName = "InterfaceName"
    case prefixLength = "PrefixLength"
  }

  /// The IPv6 addresses.
  public let addresses: [String]?
  /// The configuration method.
  public let configMethod: String
  /// The confirmed interface name.
  public let confirmedInterfaceName: String?
  /// The interface name.
  public let interfaceName: String?
  /// The prefix lengths.
  public let prefixLength: [Int]?

  /// Initializes an `IPv6` instance with the given parameters.
  ///
  /// - Parameters:
  ///   - addresses: The IPv6 addresses.
  ///   - configMethod: The configuration method.
  ///   - confirmedInterfaceName: The confirmed interface name.
  ///   - interfaceName: The interface name.
  ///   - prefixLength: The prefix lengths.
  public init(
    addresses: [String]?,
    configMethod: String,
    confirmedInterfaceName: String?,
    interfaceName: String?,
    prefixLength: [Int]?
  ) {
    self.addresses = addresses
    self.configMethod = configMethod
    self.confirmedInterfaceName = confirmedInterfaceName
    self.interfaceName = interfaceName
    self.prefixLength = prefixLength
  }
}
