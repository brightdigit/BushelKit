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

import BushelFoundation
import BushelFoundationWax
import BushelMachine
import BushelMachineWax
import Foundation
import OSVer

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
internal final class MachineSystemSpy: MachineSystem, @unchecked Sendable {
  internal typealias RestoreImageType = RestoreImageStub

  internal var id: VMSystemID { "spyOS" }

  internal private(set) var isCreateBuiderForConfigurationCalled = false
  internal private(set) var isMachineAtURLCalled = false
  internal private(set) var isRestoreImageFromCalled = false

  private let result: Result<Void, MachineSystemError>

  internal var defaultStorageLabel: String {
    "spyOS System"
  }

  internal var defaultSnapshotSystem: SnapshotterID {
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

  internal func machine(
    at url: URL,
    withConfiguration configuration: MachineConfiguration
  ) async throws
    -> MachineRegistration
  {
    isMachineAtURLCalled = true

    try handleResult()

    return MachineRegistrationObject(
      machine: MachineStub(configuration: configuration, state: .starting)
    ).register(_:_:)
  }

  internal func restoreImage(from _: any InstallerImage) async throws -> RestoreImageType {
    isRestoreImageFromCalled = true

    try handleResult()

    return .init()
  }

  internal func configurationRange(for _: any InstallerImage) -> ConfigurationRange {
    .default
  }

  internal func operatingSystemShortName(for osVer: OSVer, buildVersion: String?) -> String {
    [osVer.description, buildVersion].compactMap { $0 }.joined(separator: " ")
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
