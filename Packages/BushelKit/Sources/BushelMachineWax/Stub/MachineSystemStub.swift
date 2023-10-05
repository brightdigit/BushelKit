//
// MachineSystemStub.swift
// Copyright (c) 2023 BrightDigit.
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
  ) throws -> MachineBuilder {
    MachineBuilderStub(url: url)
  }

  public func machine(
    at _: URL,
    withConfiguration configuration: MachineConfiguration
  ) throws -> Machine {
    MachineStub(configuration: configuration, state: .starting)
  }

  public func restoreImage(from _: InstallerImage) async throws -> RestoreImageType {
    .init()
  }
}
