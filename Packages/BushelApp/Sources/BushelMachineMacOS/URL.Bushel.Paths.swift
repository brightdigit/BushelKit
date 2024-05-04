//
// URL.Bushel.Paths.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public extension URL.Bushel.Paths {
  struct VZMacValues: VZMac {
    enum Defaults {
      public static let auxiliaryStorageFileName: String = "auxiliary.storage"
      public static let hardwareModelFileName: String = "hardware.model.bin"
      public static let machineIdentifierFileName: String = "machine.identifier.bin"
    }

    public let auxiliaryStorageFileName = Defaults.auxiliaryStorageFileName
    public let hardwareModelFileName = Defaults.hardwareModelFileName
    public let machineIdentifierFileName = Defaults.machineIdentifierFileName

    public static let `default`: any VZMac = VZMacValues()
  }

  var vzMac: any VZMac {
    VZMacValues.default
  }
}
