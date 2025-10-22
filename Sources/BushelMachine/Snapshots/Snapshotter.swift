//
//  Snapshotter.swift
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

public import Foundation

/// A protocol that provides functionality
/// for creating, deleting, restoring, and exporting snapshots of a machine.
public protocol Snapshotter<MachineType> {
  /// The type of machine that this Snapshotter can handle.
  associatedtype MachineType: Machine

  /// Creates a new snapshot of the specified machine.
  ///
  /// - Parameters:
  ///   - machine: The machine to create a snapshot of.
  ///   - request: The request for the snapshot.
  ///   - options: The options to use when creating the snapshot.
  /// - Returns: The newly created snapshot.
  /// - Throws: An error that occurs during the snapshot creation process.
  func createNewSnapshot(
    of machine: MachineType,
    request: SnapshotRequest,
    options: SnapshotOptions,
    image: RecordedImage?
  ) async throws -> Snapshot

  /// Deletes the specified snapshot from the specified machine.
  ///
  /// - Parameters:
  ///   - snapshot: The snapshot to delete.
  ///   - machine: The machine from which to delete the snapshot.
  /// - Throws: An error that occurs during the snapshot deletion process.
  func deleteSnapshot(_ snapshot: Snapshot, from machine: MachineType) async throws

  /// Restores the specified snapshot to the specified machine.
  ///
  /// - Parameters:
  ///   - snapshot: The snapshot to restore.
  ///   - machine: The machine to restore the snapshot to.
  /// - Throws: An error that occurs during the snapshot restoration process.
  func restoreSnapshot(_ snapshot: Snapshot, to machine: MachineType) async throws

  /// Exports the specified snapshot from the specified machine to the given URL.
  ///
  /// - Parameters:
  ///   - snapshot: The snapshot to export.
  ///   - machine: The machine from which to export the snapshot.
  ///   - url: The URL to export the snapshot to.
  /// - Throws: An error that occurs during the snapshot export process.
  func exportSnapshot(_ snapshot: Snapshot, from machine: MachineType, to url: URL) async throws

  /// Synchronizes the snapshots for the specified machine, using the provided options.
  ///
  /// - Parameters:
  ///   - machine: The machine for which to synchronize the snapshots.
  ///   - options: The options to use when synchronizing the snapshots.
  /// - Returns: The difference between the current and synchronized snapshots,
  /// or `nil` if no difference was found.
  /// - Throws: An error that occurs during the snapshot synchronization process.
  func synchronizeSnapshots(
    for machine: MachineType,
    options: SnapshotSynchronizeOptions
  ) async throws -> SnapshotSynchronizationDifference?
}

extension Snapshotter {
  /// Synchronizes the snapshots for the specified machine, using the provided options.
  ///
  /// This default implementation always returns `nil`, indicating that no difference was found.
  ///
  /// - Parameters:
  ///   - machine: The machine for which to synchronize the snapshots.
  ///   - options: The options to use when synchronizing the snapshots.
  /// - Returns: The difference between the current and synchronized snapshots,
  /// or `nil` if no difference was found.
  /// - Throws: An error that occurs during the snapshot synchronization process.
  public func synchronizeSnapshots(
    for _: MachineType,
    options _: SnapshotSynchronizeOptions
  ) async throws -> SnapshotSynchronizationDifference? {
    nil
  }
}
