//
//  Machine+Extensions.swift
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

public import BushelLogging
public import Foundation

extension Machine {
  public static var loggingCategory: BushelLogging.Category {
    .machine
  }

  public func removeObservation(withID id: UUID?) {
    if let id {
      self.removeObservation(withID: id)
    }
  }

  public func synchronizeSnapshots(
    using provider:
      any SnapshotProvider,
    options: SnapshotSynchronizeOptions
  ) async throws {
    let configuration = await self.updatedConfiguration
    guard
      let snapshotter = provider.snapshotter(
        withID: configuration.snapshotSystemID,
        for: type(of: self)
      )
    else {
      Self.logger.critical("Unknown system: \(configuration.snapshotSystemID)")
      preconditionFailure("Unknown system: \(configuration.snapshotSystemID)")
    }
    let snapshots = try await snapshotter.synchronizeSnapshots(for: self, options: options)
    try await self.finishedWithSynchronization(snapshots)
  }

  @discardableResult
  public func createNewSnapshot(
    request: SnapshotRequest,
    options: SnapshotOptions,
    using provider: any SnapshotProvider
  ) async throws -> Snapshot {
    let configuration = await self.updatedConfiguration
    guard
      let snapshotter = provider.snapshotter(
        withID: configuration.snapshotSystemID,
        for: type(of: self)
      )
    else {
      Self.logger.critical("Unknown system: \(configuration.snapshotSystemID)")
      preconditionFailure("Unknown system: \(configuration.snapshotSystemID)")
    }

    return try await snapshotter.createNewSnapshot(of: self, request: request, options: options)
  }

  public func deleteSnapshot(
    _ snapshot: Snapshot,
    using provider: any SnapshotProvider
  ) async throws {
    let configuration = await self.updatedConfiguration
    guard
      let snapshotter = provider.snapshotter(
        withID: configuration.snapshotSystemID,
        for: type(of: self)
      )
    else {
      Self.logger.critical("Unknown system: \(configuration.snapshotSystemID)")
      preconditionFailure("Unknown system: \(configuration.snapshotSystemID)")
    }

    return try await snapshotter.deleteSnapshot(snapshot, from: self)
  }

  public func restoreSnapshot(
    _ snapshot: Snapshot,
    using provider: any SnapshotProvider
  ) async throws {
    let configuration = await self.updatedConfiguration
    guard
      let snapshotter = provider.snapshotter(
        withID: configuration.snapshotSystemID,
        for: type(of: self)
      )
    else {
      Self.logger.critical("Unknown system: \(configuration.snapshotSystemID)")
      preconditionFailure("Unknown system: \(configuration.snapshotSystemID)")
    }

    return try await snapshotter.restoreSnapshot(snapshot, to: self)
  }

  public func exportSnapshot(
    _ snapshot: Snapshot,
    to url: URL,
    using provider: any SnapshotProvider
  ) async throws {
    let configuration = await self.updatedConfiguration
    guard
      let snapshotter = provider.snapshotter(
        withID: configuration.snapshotSystemID,
        for: type(of: self)
      )
    else {
      Self.logger.critical("Unknown system: \(configuration.snapshotSystemID)")
      preconditionFailure("Unknown system: \(configuration.snapshotSystemID)")
    }

    return try await snapshotter.exportSnapshot(snapshot, from: self, to: url)
  }
}
