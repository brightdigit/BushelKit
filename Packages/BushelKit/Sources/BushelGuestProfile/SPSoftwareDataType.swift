//
// SPSoftwareDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPSoftwareDataType

public struct SPSoftwareDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case bootMode = "boot_mode"
    case bootVolume = "boot_volume"
    case kernelVersion = "kernel_version"
    case localHostName = "local_host_name"
    case osVersion = "os_version"
    case secureVM = "secure_vm"
    case systemIntegrity = "system_integrity"
    case uptime
    case userName = "user_name"
  }

  public let name: String
  public let bootMode: String
  public let bootVolume: String
  public let kernelVersion: String
  public let localHostName: String
  public let osVersion: String
  public let secureVM: String
  public let systemIntegrity: String
  public let uptime: String
  public let userName: String

  // swiftlint:disable:next line_length
  public init(name: String, bootMode: String, bootVolume: String, kernelVersion: String, localHostName: String, osVersion: String, secureVM: String, systemIntegrity: String, uptime: String, userName: String) {
    self.name = name
    self.bootMode = bootMode
    self.bootVolume = bootVolume
    self.kernelVersion = kernelVersion
    self.localHostName = localHostName
    self.osVersion = osVersion
    self.secureVM = secureVM
    self.systemIntegrity = systemIntegrity
    self.uptime = uptime
    self.userName = userName
  }
}
