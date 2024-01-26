//
// MachineSystemStub.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelCoreWax
import BushelMachine
import Foundation

public struct MachineSystemStub: MachineSystem, Equatable {
  public typealias RestoreImageType = RestoreImageStub

  public var id: VMSystemID

  public func createBuilder(
    for _: MachineBuildConfiguration<RestoreImageType>,
    at url: URL
  ) throws -> any MachineBuilder {
    MachineBuilderStub(url: url)
  }

  public func machine(
    at _: URL,
    withConfiguration configuration: MachineConfiguration
  ) throws -> any Machine {
    MachineStub(configuration: configuration, state: .starting)
  }

  public func restoreImage(from _: any InstallerImage) async throws -> RestoreImageType {
    .init()
  }

  public func configurationRange(for _: any InstallerImage) -> ConfigurationRange {
    .default
  }
}
