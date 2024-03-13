//
// IPv6.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - IPv6

public struct IPv6: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case addresses = "Addresses"
    case configMethod = "ConfigMethod"
    case confirmedInterfaceName = "ConfirmedInterfaceName"
    case interfaceName = "InterfaceName"
    case prefixLength = "PrefixLength"
  }

  public let addresses: [String]?
  public let configMethod: String
  public let confirmedInterfaceName: String?
  public let interfaceName: String?
  public let prefixLength: [Int]?

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
