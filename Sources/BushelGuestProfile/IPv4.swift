//
//  IPv4.swift
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

// MARK: - IPv4

public struct IPv4: Codable, Equatable, Sendable {
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

  public let additionalRoutes: [AdditionalRoute]?
  public let addresses: [String]?
  public let arpResolvedHardwareAddress: String?
  public let arpResolvedIPAddress: String?
  public let configMethod: String
  public let confirmedInterfaceName: String?
  public let interfaceName: String?
  public let networkSignature: String?
  public let router: String?
  public let subnetMasks: [String]?

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
