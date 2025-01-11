//
//  IPv4.swift
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

/// A struct representing an IPv4 network interface.
public struct IPv4: Codable, Equatable, Sendable {
  /// The keys used for encoding and decoding the IPv4 struct.
  public enum CodingKeys: String, CodingKey {
    case additionalRoutes = "AdditionalRoutes"
    case addresses = "Addresses"
    case arpResolvedHardwareAddress = "ARPResolvedHardwareAddress"
    case arpResolvedIPAddress = "ARPResolvedIPAddress"
    case configMethod = "ConfigMethod"
    case confirmedInterfaceName = "ConfirmedInterfaceName"
    case interfaceName = "InterfaceName"
    case networkSignature = "NetworkSignature"
    case router = "Router"
    case subnetMasks = "SubnetMasks"
  }

  /// The additional routes associated with the IPv4 network interface.
  public let additionalRoutes: [AdditionalRoute]?
  /// The IP addresses associated with the IPv4 network interface.
  public let addresses: [String]?
  /// The hardware address resolved by ARP for the IPv4 network interface.
  public let arpResolvedHardwareAddress: String?
  /// The IP address resolved by ARP for the IPv4 network interface.
  public let arpResolvedIPAddress: String?
  /// The configuration method used for the IPv4 network interface.
  public let configMethod: String
  /// The confirmed interface name for the IPv4 network interface.
  public let confirmedInterfaceName: String?
  /// The interface name for the IPv4 network interface.
  public let interfaceName: String?
  /// The network signature for the IPv4 network interface.
  public let networkSignature: String?
  /// The router associated with the IPv4 network interface.
  public let router: String?
  /// The subnet masks associated with the IPv4 network interface.
  public let subnetMasks: [String]?

  /// Initializes an IPv4 struct with the provided parameters.
  /// - Parameters:
  ///   - additionalRoutes: The additional routes associated with the IPv4 network interface.
  ///   - addresses: The IP addresses associated with the IPv4 network interface.
  ///   - arpResolvedHardwareAddress: The hardware address resolved by ARP for the IPv4 network interface.
  ///   - arpResolvedIPAddress: The IP address resolved by ARP for the IPv4 network interface.
  ///   - configMethod: The configuration method used for the IPv4 network interface.
  ///   - confirmedInterfaceName: The confirmed interface name for the IPv4 network interface.
  ///   - interfaceName: The interface name for the IPv4 network interface.
  ///   - networkSignature: The network signature for the IPv4 network interface.
  ///   - router: The router associated with the IPv4 network interface.
  ///   - subnetMasks: The subnet masks associated with the IPv4 network interface.
  public init(
    additionalRoutes: [AdditionalRoute]?,
    addresses: [String]?,
    arpResolvedHardwareAddress: String?,
    arpResolvedIPAddress: String?,
    configMethod: String,
    confirmedInterfaceName: String?,
    interfaceName: String?,
    networkSignature: String?,
    router: String?,
    subnetMasks: [String]?
  ) {
    self.additionalRoutes = additionalRoutes
    self.addresses = addresses
    self.arpResolvedHardwareAddress = arpResolvedHardwareAddress
    self.arpResolvedIPAddress = arpResolvedIPAddress
    self.configMethod = configMethod
    self.confirmedInterfaceName = confirmedInterfaceName
    self.interfaceName = interfaceName
    self.networkSignature = networkSignature
    self.router = router
    self.subnetMasks = subnetMasks
  }
}
