//
// MachineStub.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine
import Foundation

public struct MachineStub: Machine {
  public var machineIdentifer: UInt64? {
    nil
  }

  public let configuration: MachineConfiguration
  public let state: MachineState

  public let canStart: Bool = false
  public let canStop: Bool = false
  public let canPause: Bool = false
  public let canResume: Bool = false
  public let canRequestStop: Bool = false

  public init(configuration: MachineConfiguration, state: MachineState) {
    self.configuration = configuration
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

  public func beginObservation(_: @escaping @MainActor (BushelMachine.MachineChange) -> Void) -> UUID {
    UUID()
  }

  public func removeObservation(withID _: UUID) -> Bool {
    true
  }

  // swiftlint:disable:next unavailable_function
  public func beginSnapshot() -> BushelMachine.SnapshotPaths {
    fatalError("Not implemented")
  }

  // swiftlint:disable:next unavailable_function
  public func finishedWithSnapshot(_: BushelMachine.Snapshot, by _: BushelMachine.SnapshotDifference) {
    fatalError("Not implemented")
  }

  // swiftlint:disable:next unavailable_function
  public func finishedWithSyncronization(_: BushelMachine.SnapshotSyncronizationDifference?) throws {
    fatalError("Not implemented")
  }

  // swiftlint:disable:next unavailable_function
  public func updatedMetadata(forSnapshot _: BushelMachine.Snapshot, atIndex _: Int) {
    fatalError("Not implemented")
  }
}
