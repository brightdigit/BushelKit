//
// ConfigurationRange.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation
public struct ConfigurationRange: CustomStringConvertible, Sendable, Equatable {
  public static let `default` = ConfigurationRange(
    cpuCount: 1 ... 4,
    memory: (8 * 1024 * 1024 * 1024) ... (128 * 1024 * 1024 * 1024)
  )

  public let cpuCount: ClosedRange<Float>
  public let memory: ClosedRange<Float>

  public var description: String {
    "cpuCount: \(cpuCount); memory: \(memory)"
  }

  public init(cpuCount: ClosedRange<Float>, memory: ClosedRange<Float>) {
    self.cpuCount = cpuCount
    self.memory = memory
  }
}
