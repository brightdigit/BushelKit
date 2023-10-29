//
// Machine.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

#if canImport(SwiftUI)
  import SwiftUI
#endif

public protocol Machine: LoggerCategorized {
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

  func beginSnapshot() -> SnapshotPaths

  func finishedWithSnapshot(_ snapshot: Snapshot, by difference: SnapshotDifference)

  func updatedMetadata(forSnapshot snapshot: Snapshot, atIndex index: Int)

  func beginObservation(_ update: @escaping @MainActor (MachineChange) -> Void) -> UUID

  @discardableResult
  func removeObservation(withID id: UUID) -> Bool
}

public extension Machine {
  static var loggingCategory: Loggers.LoggerCategory {
    .machine
  }

  @discardableResult
  func removeObservation(withID id: UUID?) -> Bool {
    if let id {
      return self.removeObservation(withID: id)
    }
    return false
  }

  @discardableResult
  func createNewSnapshot(
    request: SnapshotRequest,
    options: SnapshotOptions,
    using provider: SnapshotProvider
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

  func deleteSnapshot(
    _ snapshot: Snapshot,
    using provider: SnapshotProvider
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

  func restoreSnapshot(
    _ snapshot: Snapshot,
    using provider: SnapshotProvider
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

  func exportSnapshot(
    _ snapshot: Snapshot,
    to url: URL,
    using provider: SnapshotProvider
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
