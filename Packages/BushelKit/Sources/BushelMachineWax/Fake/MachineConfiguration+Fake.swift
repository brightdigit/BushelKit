//
// MachineConfiguration+Fake.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine
import Foundation

public extension MachineConfiguration {
  static let sampleMachineConfiguration: Self = .init(
    restoreImageFile: .sampleInstallerIdentifier,
    vmSystemID: .sampleVMSystemID,
    snapshotSystemID: .sampleSnapshotSystemID,
    operatingSystemVersion: .init(
      majorVersion: 1,
      minorVersion: 0,
      patchVersion: 0
    ),
    storage: [.init(label: "", size: MachineStorageSpecification.defaultSize)]
  )
}
