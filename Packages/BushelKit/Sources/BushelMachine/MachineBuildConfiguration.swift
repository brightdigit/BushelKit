//
// MachineBuildConfiguration.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public struct MachineBuildConfiguration<RestoreImageType> {
  public init(configuration: MachineConfiguration, restoreImage: RestoreImageType) {
    self.configuration = configuration
    self.restoreImage = restoreImage
  }

  public let configuration: MachineConfiguration
  public let restoreImage: RestoreImageType
}
