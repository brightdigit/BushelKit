//
// MachineConfiguration+Fake.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelMachine
import Foundation

public extension MachineConfiguration {
  static let sampleMachineConfiguration: Self = .init(
    restoreImageFile: .sampleInstallerIdentifier,
    vmSystem: .sampleVMSystemID,
    operatingSystemVersion: .init(
      majorVersion: 1,
      minorVersion: 0,
      patchVersion: 0
    )
  )
}
