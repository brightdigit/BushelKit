//
// MachineStub.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelMachine
import Foundation

public struct MachineStub: Machine {
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

  public func beginSnapshot() -> BushelMachine.SnapshotPaths {
    fatalError("Not implemented")
  }

  public func finishedWithSnapshot(_: BushelMachine.Snapshot, by _: BushelMachine.SnapshotDifference) {
    fatalError("Not implemented")
  }
}
