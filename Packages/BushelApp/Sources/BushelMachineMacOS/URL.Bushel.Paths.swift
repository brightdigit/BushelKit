//
// URL.Bushel.Paths.swift
// Copyright (c) 2024 BrightDigit.
//

public import BushelCore

public import Foundation

extension URL.Bushel.Paths {
  public struct VZMacValues: VZMac {
    internal enum Defaults {
      static let auxiliaryStorageFileName: String = "auxiliary.storage"
      static let hardwareModelFileName: String = "hardware.model.bin"
      static let machineIdentifierFileName: String = "machine.identifier.bin"
    }

    public let auxiliaryStorageFileName = Defaults.auxiliaryStorageFileName
    public let hardwareModelFileName = Defaults.hardwareModelFileName
    public let machineIdentifierFileName = Defaults.machineIdentifierFileName

    public static let `default`: any VZMac = VZMacValues()
  }

  public var vzMac: any VZMac {
    VZMacValues.default
  }
}
