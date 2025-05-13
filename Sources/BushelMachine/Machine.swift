//
//  Machine.swift
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

public import BushelLogging
public import Foundation

#if canImport(SwiftUI)
  internal import SwiftUI
#endif

/// A protocol that defines the behavior of a machine.
public protocol Machine: Loggable, Sendable {
  /// The unique identifier of the machine.
  var machineIdentifer: UInt64? { get }

  /// The initial configuration of the machine.
  var initialConfiguration: MachineConfiguration { get }

  /// The updated configuration of the machine.
  var updatedConfiguration: MachineConfiguration { get async }

  /// Starts the machine.
  ///
  /// - Throws: An error if the machine failed to start.
  func start() async throws

  /// Pauses the machine.
  ///
  /// - Throws: An error if the machine failed to pause.
  func pause() async throws

  /// Stops the machine.
  ///
  /// - Throws: An error if the machine failed to stop.
  func stop() async throws

  /// Resumes the machine.
  ///
  /// - Throws: An error if the machine failed to resume.
  func resume() async throws

  /// Requests that the guest turns itself off.
  ///
  /// - Parameter error: If not nil, assigned with the error if the request failed.
  /// - Returns: `true` if the request was made successfully.
  func requestStop() async throws

  /// Begins a snapshot of the machine.
  ///
  /// - Returns: The paths of the snapshot.
  func beginSnapshot() throws -> SnapshotPaths

  /// Finishes the snapshot of the machine.
  ///
  /// - Parameter snapshot: The snapshot.
  /// - Parameter difference: The snapshot difference.
  func finishedWithSnapshot(_ snapshot: Snapshot, by difference: SnapshotDifference) async

  /// Finishes the synchronization of the machine.
  ///
  /// - Parameter difference: The snapshot synchronization difference.
  func finishedWithSynchronization(_ difference: SnapshotSynchronizationDifference?) async throws

  /// Updates the metadata for a specific snapshot.
  ///
  /// - Parameter snapshot: The snapshot.
  /// - Parameter index: The index of the snapshot.
  func updatedMetadata(forSnapshot snapshot: Snapshot, atIndex index: Int) async

  /// Begins observing changes to the machine.
  ///
  /// - Parameter update: The closure to be called when a change occurs.
  /// - Returns: The UUID of the observation.
  func beginObservation(_ update: @escaping @Sendable (MachineChange) -> Void) -> UUID

  /// Removes an observation from the machine.
  ///
  /// - Parameter id: The UUID of the observation to remove.
  func removeObservation(withID id: UUID)

  /// Saves a captured video.
  ///
  /// - Parameter closure: The closure to be called to save the video.
  /// - Returns: The recorded video.
  func saveCaptureVideo(with closure: @escaping @Sendable (URL) async throws -> RecordedVideo)
    async rethrows -> RecordedVideo

  /// Saves a captured image.
  ///
  /// - Parameter closure: The closure to be called to save the image.
  /// - Returns: The recorded image.
  func saveCaptureImage(with closure: @escaping @Sendable (URL) async throws -> RecordedImage)
    async throws -> RecordedImage

  /// Updates the metadata for a captured video.
  ///
  /// - Parameter video: The recorded video.
  func updatedMetadata(forVideo video: RecordedVideo) async

  /// Updates the metadata for a captured image.
  ///
  /// - Parameter image: The recorded image.
  func updatedMetadata(forImage image: RecordedImage) async

  /// Deletes a captured video.
  ///
  /// - Parameter id: The UUID of the video to delete.
  func deleteCapturedVideoWithID(_ id: UUID) async throws

  /// Deletes a captured image.
  ///
  /// - Parameter id: The UUID of the image to delete.
  func deleteCapturedImageWithID(_ id: UUID) async throws
}
