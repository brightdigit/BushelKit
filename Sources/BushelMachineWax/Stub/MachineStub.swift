//
//  MachineStub.swift
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

public import BushelMachine
public import Foundation

public struct MachineStub: Machine {
  public var updatedConfiguration: BushelMachine.MachineConfiguration

  public var machineIdentifer: UInt64? {
    nil
  }

  public let initialConfiguration: MachineConfiguration
  public let state: MachineState

  public let canStart = false
  public let canStop = false
  public let canPause = false
  public let canResume = false
  public let canRequestStop = false

  public init(configuration: MachineConfiguration, state: MachineState) {
    self.initialConfiguration = configuration
    self.updatedConfiguration = configuration
    self.state = state
  }

  public func start() async throws {
    // nothing for now
  }

  public func pause() async throws {
    // nothing for now
  }

  public func stop() async throws {
    // nothing for now
  }

  public func resume() async throws {
    // nothing for now
  }

  public func restoreMachineStateFrom(url _: URL) async throws {
    // nothing for now
  }

  public func saveMachineStateTo(url _: URL) async throws {
    // nothing for now
  }

  public func requestStop() async throws {
    // nothing for now
  }

  public func beginObservation(_: @escaping @Sendable (BushelMachine.MachineChange) -> Void) -> UUID
  {
    UUID()
  }

  public func removeObservation(withID _: UUID) {}

  // swiftlint:disable:next unavailable_function
  public func beginSnapshot() -> BushelMachine.SnapshotPaths {
    fatalError("Not implemented")
  }

  // swiftlint:disable:next unavailable_function
  public func finishedWithSnapshot(
    _: BushelMachine.Snapshot, by _: BushelMachine.SnapshotDifference
  ) {
    fatalError("Not implemented")
  }

  // swiftlint:disable:next unavailable_function
  public func finishedWithSynchronization(_: BushelMachine.SnapshotSynchronizationDifference?)
    throws
  {
    fatalError("Not implemented")
  }

  // swiftlint:disable:next unavailable_function
  public func updatedMetadata(forSnapshot _: BushelMachine.Snapshot, atIndex _: Int) {
    fatalError("Not implemented")
  }

  // swiftlint:disable:next unavailable_function
  public func saveCaptureVideo(
    with closure: @escaping @Sendable (URL) async throws -> BushelMachine.RecordedVideo
  ) async rethrows -> BushelMachine.RecordedVideo {
    fatalError("Not implemented")
  }

  // swiftlint:disable:next unavailable_function
  public func saveCaptureImage(
    with closure: @escaping @Sendable (URL) async throws -> BushelMachine.RecordedImage
  ) async throws -> BushelMachine.RecordedImage {
    fatalError("Not implemented")
  }

  // swiftlint:disable:next unavailable_function
  public func updatedMetadata(forVideo video: BushelMachine.RecordedVideo) async {
    fatalError("Not implemented")
  }

  // swiftlint:disable:next unavailable_function
  public func updatedMetadata(forImage image: BushelMachine.RecordedImage) async {
    fatalError("Not implemented")
  }

  // swiftlint:disable:next unavailable_function
  public func deleteCapturedImageWithID(_ id: UUID) async throws {
    fatalError("Not implemented")
  }

  // swiftlint:disable:next unavailable_function
  public func deleteCapturedVideoWithID(_ id: UUID) async throws {
    fatalError("Not implemented")
  }
}
