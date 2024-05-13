//
//  Machine.swift
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
import BushelLogging
import Foundation

#if canImport(SwiftUI)
  import SwiftUI
#endif

public protocol Machine: Loggable, Sendable {
  var machineIdentifer: UInt64? { get }
  var configuration: MachineConfiguration { get }

  /// Execution state of the virtual machine.
  var state: MachineState { get }

  /// Return YES if the machine is in a state that can be started.
  ///
  /// - SeeAlso: ``start()``
  /// - SeeAlso: ``state``
  var canStart: Bool { get }

  /// Return YES if the machine is in a state that can be stopped.
  ///
  /// - SeeAlso: ``stop()``
  /// - SeeAlso: ``state``
  var canStop: Bool { get }

  /// Return YES if the machine is in a state that can be paused.
  ///
  /// - SeeAlso: ``pause()``
  /// - SeeAlso: ``state``
  var canPause: Bool { get }

  /// Return YES if the machine is in a state that can be resumed.
  ///
  /// - SeeAlso: ``resume()``
  /// - SeeAlso: ``state``
  var canResume: Bool { get }

  /// Returns whether the machine is in a state where the guest can be asked to stop.
  ///
  /// - SeeAlso: ``requestStop()``
  /// - SeeAlso: ``state``
  var canRequestStop: Bool { get }

  func start() async throws
  func pause() async throws
  func stop() async throws
  func resume() async throws

  /// Request that the guest turns itself off.
  ///
  /// - Parameter error: If not nil, assigned with the error if the request failed.
  /// - Returns: true if the request was made successfully.
  func requestStop() async throws

  func beginSnapshot() throws -> SnapshotPaths

  func finishedWithSnapshot(_ snapshot: Snapshot, by difference: SnapshotDifference)

  func finishedWithSyncronization(_ difference: SnapshotSyncronizationDifference?) throws

  func updatedMetadata(forSnapshot snapshot: Snapshot, atIndex index: Int)

  func beginObservation(_ update: @escaping @Sendable @MainActor (MachineChange) -> Void) -> UUID

  @discardableResult
  func removeObservation(withID id: UUID) -> Bool
}

extension Machine {
  public static var loggingCategory: BushelLogging.Category {
    .machine
  }

  @discardableResult
  public func removeObservation(withID id: UUID?) -> Bool {
    if let id {
      return self.removeObservation(withID: id)
    }
    return false
  }

  public func syncronizeSnapshots(
    using provider:
    any SnapshotProvider,
    options: SnapshotSyncronizeOptions
  ) async throws {
    guard let snapshotter = provider.snapshotter(
      withID: self.configuration.snapshotSystemID,
      for: type(of: self)
    ) else {
      Self.logger.critical("Unknown system: \(self.configuration.snapshotSystemID)")
      preconditionFailure("Unknown system: \(self.configuration.snapshotSystemID)")
    }
    let snapshots = try await snapshotter.syncronizeSnapshots(for: self, options: options)
    try self.finishedWithSyncronization(snapshots)
  }

  @discardableResult
  public func createNewSnapshot(
    request: SnapshotRequest,
    options: SnapshotOptions,
    using provider: any SnapshotProvider
  ) async throws -> Snapshot {
    guard let snapshotter = provider.snapshotter(
      withID: self.configuration.snapshotSystemID,
      for: type(of: self)
    ) else {
      Self.logger.critical("Unknown system: \(self.configuration.snapshotSystemID)")
      preconditionFailure("Unknown system: \(self.configuration.snapshotSystemID)")
    }

    return try await snapshotter.createNewSnapshot(of: self, request: request, options: options)
  }

  public func deleteSnapshot(
    _ snapshot: Snapshot,
    using provider: any SnapshotProvider
  ) throws {
    guard let snapshotter = provider.snapshotter(
      withID: self.configuration.snapshotSystemID,
      for: type(of: self)
    ) else {
      Self.logger.critical("Unknown system: \(self.configuration.snapshotSystemID)")
      preconditionFailure("Unknown system: \(self.configuration.snapshotSystemID)")
    }

    return try snapshotter.deleteSnapshot(snapshot, from: self)
  }

  public func restoreSnapshot(
    _ snapshot: Snapshot,
    using provider: any SnapshotProvider
  ) async throws {
    guard let snapshotter = provider.snapshotter(
      withID: self.configuration.snapshotSystemID,
      for: type(of: self)
    ) else {
      Self.logger.critical("Unknown system: \(self.configuration.snapshotSystemID)")
      preconditionFailure("Unknown system: \(self.configuration.snapshotSystemID)")
    }

    return try await snapshotter.restoreSnapshot(snapshot, to: self)
  }

  public func exportSnapshot(
    _ snapshot: Snapshot,
    to url: URL,
    using provider: any SnapshotProvider
  ) async throws {
    guard let snapshotter = provider.snapshotter(
      withID: self.configuration.snapshotSystemID,
      for: type(of: self)
    ) else {
      Self.logger.critical("Unknown system: \(self.configuration.snapshotSystemID)")
      preconditionFailure("Unknown system: \(self.configuration.snapshotSystemID)")
    }

    return try await snapshotter.exportSnapshot(snapshot, from: self, to: url)
  }
}
