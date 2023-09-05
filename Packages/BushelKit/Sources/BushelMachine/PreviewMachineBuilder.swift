//
// PreviewMachineBuilder.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public class PreviewMachineBuilder: MachineBuilder {
  public func observePercentCompleted(_: @escaping (Double) -> Void) -> UUID {
    .init()
  }

  public func removeObserver(_: UUID) -> Bool {
    false
  }

  public init(url: URL? = nil) {
    self.url = url ?? .randomFile()
  }

  public let url: URL

  public func build() async throws {}
}
