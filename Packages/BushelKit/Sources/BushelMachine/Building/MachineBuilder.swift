//
// MachineBuilder.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol MachineBuilder: Sendable {
  var url: URL { get }
  func observePercentCompleted(_ onUpdate: @escaping @Sendable (Double) -> Void) -> UUID
  @discardableResult
  func removeObserver(_ id: UUID) -> Bool
  func build() async throws
}
