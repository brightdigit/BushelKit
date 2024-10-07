//
//  SnapshotterFactory.swift
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

public import BushelCore
public import BushelLogging

public protocol SnapshotterFactory: Loggable, Sendable {
  static var systemID: SnapshotterID { get }
  func createNewSnapshot(
    of machine: some Machine,
    request: SnapshotRequest,
    options: SnapshotOptions
  ) async throws -> Snapshot
  func snapshotter<MachineType: Machine>(supports: MachineType.Type) -> (
    any Snapshotter<MachineType>
  )?
}

extension SnapshotterFactory {
  public static var loggingCategory: BushelLogging.Category {
    .machine
  }

  internal func createNewSnapshot(
    of machine: some Machine,
    request: SnapshotRequest,
    options: SnapshotOptions
  ) async throws -> Snapshot {
    guard let snapshotter = self.snapshotter(supports: type(of: machine).self) else {
      Self.logger.critical("Unknown system: \(type(of: machine).self)")
      preconditionFailure("Unknown system: \(type(of: machine).self)")
    }

    return try await snapshotter.createNewSnapshot(of: machine, request: request, options: options)
  }
}