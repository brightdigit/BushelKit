//
// SPHardwareDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPHardwareDataType

public struct SPHardwareDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case activationLockStatus = "activation_lock_status"
    case bootROMVersion = "boot_rom_version"
    case chipType = "chip_type"
    case machineModel = "machine_model"
    case machineName = "machine_name"
    case numberProcessors = "number_processors"
    case osLoaderVersion = "os_loader_version"
    case physicalMemory = "physical_memory"
    case platformUUID = "platform_UUID"
    case provisioningUDID = "provisioning_UDID"
    case serialNumber = "serial_number"
  }

  public let name: String
  public let activationLockStatus: String
  public let bootROMVersion: String
  public let chipType: String
  public let machineModel: String
  public let machineName: String
  public let numberProcessors: String
  public let osLoaderVersion: String
  public let physicalMemory: String
  public let platformUUID: String
  public let provisioningUDID: String
  public let serialNumber: String

  // swiftlint:disable:next line_length
  public init(name: String, activationLockStatus: String, bootROMVersion: String, chipType: String, machineModel: String, machineName: String, numberProcessors: String, osLoaderVersion: String, physicalMemory: String, platformUUID: String, provisioningUDID: String, serialNumber: String) {
    self.name = name
    self.activationLockStatus = activationLockStatus
    self.bootROMVersion = bootROMVersion
    self.chipType = chipType
    self.machineModel = machineModel
    self.machineName = machineName
    self.numberProcessors = numberProcessors
    self.osLoaderVersion = osLoaderVersion
    self.physicalMemory = physicalMemory
    self.platformUUID = platformUUID
    self.provisioningUDID = provisioningUDID
    self.serialNumber = serialNumber
  }
}
