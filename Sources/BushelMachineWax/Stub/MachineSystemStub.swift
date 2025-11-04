//
//  MachineSystemStub.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

public import BushelFoundation
public import BushelFoundationWax
public import BushelMachine
public import Foundation
public import OSVer

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
public struct MachineSystemStub: MachineSystem, Equatable {
  public typealias RestoreImageType = RestoreImageStub

  public let defaultStorageLabel: String = "stub"

  public let defaultSnapshotSystem: SnapshotterID = "testing"

  public var id: VMSystemID

  public func createBuilder(
    for _: MachineBuildConfiguration<RestoreImageType>,
    at url: URL
  ) throws -> any MachineBuilder {
    MachineBuilderStub(url: url)
  }

  public func machine(at url: URL, withConfiguration configuration: MachineConfiguration)
    async throws -> MachineRegistration
  {
    MachineRegistrationObject(
      machine: MachineStub(configuration: configuration, state: .starting)
    ).register(_:_:)
  }

  public func restoreImage(from _: any InstallerImage) async throws -> RestoreImageType {
    .init()
  }

  public func configurationRange(for _: any InstallerImage) -> ConfigurationRange {
    .default
  }

  public func operatingSystemShortName(for osVer: OSVer, buildVersion: String?) -> String {
    [osVer.description, buildVersion].compactMap { $0 }.joined(separator: " ")
  }
}
