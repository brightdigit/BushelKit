//
// VZMacPlatformConfiguration.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import Combine
import Virtualization

enum VirtualizationError: Error {
  case undefinedType(String, Any?)
}

extension VZMacPlatformConfiguration {
  convenience init(fromDirectory machineDirectory: URL) throws {
    self.init()
    let auxiliaryStorageURL = machineDirectory.appendingPathComponent("auxiliary.storage")
    let hardwareModelURL = machineDirectory.appendingPathComponent("hardware.model.bin")
    let machineIdentifierURL = machineDirectory.appendingPathComponent("machine.identifier.bin")
    if #available(macOS 13.0, *) {
      self.auxiliaryStorage = VZMacAuxiliaryStorage(url: auxiliaryStorageURL)
    } else {
      auxiliaryStorage = VZMacAuxiliaryStorage(contentsOf: auxiliaryStorageURL)
    }

    guard let hardwareModel = VZMacHardwareModel(dataRepresentation: try Data(contentsOf: hardwareModelURL)) else {
      throw VirtualizationError.undefinedType("Invalid hardware model url", hardwareModelURL)
    }
    self.hardwareModel = hardwareModel
    guard let machineIdentifier = VZMacMachineIdentifier(dataRepresentation: try .init(contentsOf: machineIdentifierURL)) else {
      throw VirtualizationError.undefinedType("Invalid machineIdentifierURL", machineIdentifierURL)
    }
    self.machineIdentifier = machineIdentifier
  }

  convenience init(restoreImage: VZMacOSRestoreImage, in machineDirectory: URL) throws {
    self.init()

    guard let configuration = restoreImage.mostFeaturefulSupportedConfiguration else {
      throw NSError()
    }

    try FileManager.default.createDirectory(at: machineDirectory, withIntermediateDirectories: true)
    let auxiliaryStorageURL = machineDirectory.appendingPathComponent("auxiliary.storage")
    let hardwareModelURL = machineDirectory.appendingPathComponent("hardware.model.bin")
    let machineIdentifierURL = machineDirectory.appendingPathComponent("machine.identifier.bin")

    let auxiliaryStorage = try VZMacAuxiliaryStorage(creatingStorageAt: auxiliaryStorageURL,
                                                     hardwareModel: configuration.hardwareModel,
                                                     options: [])

    self.auxiliaryStorage = auxiliaryStorage
    hardwareModel = configuration.hardwareModel
    machineIdentifier = .init()

    try hardwareModel.dataRepresentation.write(to: hardwareModelURL)
    try machineIdentifier.dataRepresentation.write(to: machineIdentifierURL)
  }
}
