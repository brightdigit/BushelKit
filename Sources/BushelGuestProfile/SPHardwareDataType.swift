//
//  SPHardwareDataType.swift
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

/// Represents a data type for hardware information.
public struct SPHardwareDataType: Codable, Equatable, Sendable {
  /// The coding keys for the hardware data type.
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

  /// The name of the hardware.
  public let name: String
  /// The activation lock status of the hardware.
  public let activationLockStatus: String
  /// The boot ROM version of the hardware.
  public let bootROMVersion: String
  /// The chip type of the hardware.
  public let chipType: String
  /// The machine model of the hardware.
  public let machineModel: String
  /// The machine name of the hardware.
  public let machineName: String
  /// The number of processors in the hardware.
  public let numberProcessors: String
  /// The OS loader version of the hardware.
  public let osLoaderVersion: String
  /// The physical memory of the hardware.
  public let physicalMemory: String
  /// The platform UUID of the hardware.
  public let platformUUID: String
  /// The provisioning UDID of the hardware.
  public let provisioningUDID: String
  /// The serial number of the hardware.
  public let serialNumber: String

  /// Initializes a new instance of `SPHardwareDataType`.
  /// - Parameters:
  ///   - name: The name of the hardware.
  ///   - activationLockStatus: The activation lock status of the hardware.
  ///   - bootROMVersion: The boot ROM version of the hardware.
  ///   - chipType: The chip type of the hardware.
  ///   - machineModel: The machine model of the hardware.
  ///   - machineName: The machine name of the hardware.
  ///   - numberProcessors: The number of processors in the hardware.
  ///   - osLoaderVersion: The OS loader version of the hardware.
  ///   - physicalMemory: The physical memory of the hardware.
  ///   - platformUUID: The platform UUID of the hardware.
  ///   - provisioningUDID: The provisioning UDID of the hardware.
  ///   - serialNumber: The serial number of the hardware.
  public init(
    name: String,
    activationLockStatus: String,
    bootROMVersion: String,
    chipType: String,
    machineModel: String,
    machineName: String,
    numberProcessors: String,
    osLoaderVersion: String,
    physicalMemory: String,
    platformUUID: String,
    provisioningUDID: String,
    serialNumber: String
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
