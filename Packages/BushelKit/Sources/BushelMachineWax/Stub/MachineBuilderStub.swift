//
// MachineBuilderStub.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine
import Foundation

public struct MachineBuilderStub: MachineBuilder {
  public let url: URL

  public init(url: URL) {
    self.url = url
  }

  public func observePercentCompleted(_: @escaping (Double) -> Void) -> UUID {
    .init()
  }

  public func removeObserver(_: UUID) -> Bool {
    true
  }

  public func build() async throws {
    // nothing now
  }
}
