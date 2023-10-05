//
// MachineBuildConfiguration+Fake.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCoreWax
import BushelMachine
import Foundation

public extension MachineBuildConfiguration where RestoreImageType == RestoreImageStub {
  static let sampleMachineBuildConfiguration: Self = .init(
    configuration: .sampleMachineConfiguration,
    restoreImage: .init()
  )
}
