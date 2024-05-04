//
// MachineSystemSpy.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelCoreWax
import BushelMachine
import BushelMachineWax
import Foundation

internal final class MachineSystemSpy: MachineSystem, Sendable {
  typealias RestoreImageType = RestoreImageStub

  internal var id: VMSystemID { "spyOS" }

  private(set) var isCreateBuiderForConfigurationCalled: Bool = false
  private(set) var isMachineAtURLCalled: Bool = false
  private(set) var isRestoreImageFromCalled: Bool = false

  private let result: Result<Void, MachineSystemError>

  var defaultStorageLabel: String {
    "spyOS System"
  }

  var defaultSnapshotSystem: BushelCore.SnapshotterID {
    "spysnapshot"
  }

  internal init(result: Result<Void, MachineSystemError>) {
    self.result = result
  }

  internal func createBuilder(
    for _: MachineBuildConfiguration<RestoreImageType>,
    at url: URL
  ) throws -> any MachineBuilder {
    isCreateBuiderForConfigurationCalled = true

    try handleResult()

    return MachineBuilderStub(url: url)
  }

  internal func machine(
    at _: URL,
    withConfiguration configuration: MachineConfiguration
  ) throws -> any Machine {
    isMachineAtURLCalled = true

    try handleResult()

    return MachineStub(configuration: configuration, state: .starting)
  }

  internal func restoreImage(from _: any InstallerImage) async throws -> RestoreImageType {
    isRestoreImageFromCalled = true

    try handleResult()

    return .init()
  }

  func configurationRange(for _: any InstallerImage) -> ConfigurationRange {
    .default
  }

  private func handleResult() throws {
    switch result {
    case .success:
      break

    case let .failure(failure):
      throw failure
    }
  }
}
