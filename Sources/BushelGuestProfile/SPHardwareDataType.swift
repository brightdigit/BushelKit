//
//  SPHardwareDataType.swift
//  BushelKit
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

// MARK: - SPHardwareDataType

public struct SPHardwareDataType: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
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
  public init(
    name: String, activationLockStatus: String, bootROMVersion: String, chipType: String,
    machineModel: String, machineName: String, numberProcessors: String, osLoaderVersion: String,
    physicalMemory: String, platformUUID: String, provisioningUDID: String, serialNumber: String
  ) {
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
