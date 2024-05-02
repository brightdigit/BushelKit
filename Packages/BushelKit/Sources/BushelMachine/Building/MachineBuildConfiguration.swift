//
// MachineBuildConfiguration.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

///  Used by the `MachineSystem` to build a new virtual machine.
public struct MachineBuildConfiguration<RestoreImageType: Sendable>: Sendable {
  /// Hardware configuration of the machine.
  public let configuration: MachineConfiguration

  /// The install image to use for the vritual machine.
  public let restoreImage: RestoreImageType

  /// Creates a build configuration for a new virtual machine.
  /// - Parameters:
  ///   - configuration: The hardware configuration.
  ///   - restoreImage: The install image.
  public init(configuration: MachineConfiguration, restoreImage: RestoreImageType) {
    self.configuration = configuration
    self.restoreImage = restoreImage
  }
}
