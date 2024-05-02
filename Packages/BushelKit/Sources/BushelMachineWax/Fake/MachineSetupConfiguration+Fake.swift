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
    storage: [.init(label: "", size: MachineStorageSpecification.defaultSize)],
    cpuCount: 1,
    memory: 1024 * 1024,
    networkConfigurations: [.default()],
    graphicsConfigurations: [.default()]
  )
}
