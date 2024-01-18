//
// MachineSetupConfiguration+Fake.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine
import Foundation

public extension MachineSetupConfiguration {
  static let sampleMachineSetupConfiguration: Self = .init(
    libraryID: .sampleLibraryID,
    restoreImageID: .imageIDSample,
    storage: [.default],
    cpuCount: 1,
    memory: 1,
    networkConfigurations: [.default()],
    graphicsConfigurations: [.default()]
  )
}
