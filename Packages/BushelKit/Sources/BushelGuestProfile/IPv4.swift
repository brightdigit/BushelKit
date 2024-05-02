//
// IPv4.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - IPv4

public struct IPv4: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
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
