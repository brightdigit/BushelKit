//
//  SnapshotterFactory.swift
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
public import BushelLogging

/// A factory for creating snapshots of machines.
public protocol SnapshotterFactory: Loggable, Sendable {
  /// The unique identifier for the system this `SnapshotterFactory` supports.
  static var systemID: SnapshotterID { get }

  /// Creates a new snapshot of the specified machine.
  ///
  /// - Parameters:
  ///   - machine: The machine to create a snapshot of.
  ///   - request: The request for the snapshot.
  ///   - options: The options to use for the snapshot.
  /// - Returns: The created snapshot.
  /// - Throws: Any errors that occur during the snapshot creation process.
  func createNewSnapshot(
    of machine: some Machine,
    request: SnapshotRequest,
    options: SnapshotOptions,
    image: RecordedImage?
  ) async throws -> Snapshot

  /// Retrieves a snapshotter that supports the specified machine type.
  ///
  /// - Parameter supports: The type of machine to retrieve a snapshotter for.
  /// - Returns: A snapshotter that supports the specified machine type,
  /// or `nil` if no such snapshotter is available.
  func snapshotter<MachineType: Machine>(supports: MachineType.Type) -> (
    any Snapshotter<MachineType>
  )?
}

extension SnapshotterFactory {
  /// The logging category for this `SnapshotterFactory`.
  public static var loggingCategory: BushelLogging.Category {
    .machine
  }

  /// Internal implementation of `createNewSnapshot(of:request:options:)`.
  internal func createNewSnapshot(
    of machine: some Machine,
    request: SnapshotRequest,
    options: SnapshotOptions,
    image: RecordedImage?
  ) async throws -> Snapshot {
    guard let snapshotter = self.snapshotter(supports: type(of: machine).self) else {
      Self.logger.critical("Unknown system: \(type(of: machine).self)")
      preconditionFailure("Unknown system: \(type(of: machine).self)")
    }

    return try await snapshotter.createNewSnapshot(
      of: machine,
      request: request,
      options: options,
      image: image
    )
  }
}
