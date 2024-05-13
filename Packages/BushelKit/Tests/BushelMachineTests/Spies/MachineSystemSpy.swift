//
//  MachineSystemSpy.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import BushelCore
import BushelCoreWax
import BushelMachine
import BushelMachineWax
import Foundation

internal final class MachineSystemSpy: MachineSystem, Sendable {
  typealias RestoreImageType = RestoreImageStub

  internal var id: VMSystemID { "spyOS" }

  private(set) var isCreateBuiderForConfigurationCalled = false
  private(set) var isMachineAtURLCalled = false
  private(set) var isRestoreImageFromCalled = false

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
