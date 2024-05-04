//
// Specifications.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum Specifications {
  static let fullMemoryRange = 1 ... 11
  static let fullStorageRange = 36 ... 42
  public static let fullStorageBoundsRange: ClosedRange<Float> = .init(intRange: fullStorageRange)

  private static func handler(
    using: @escaping @Sendable (Int, Int) -> Int) -> @Sendable (any CalculationParameters) -> Int {
    { $0.value(using: using) }
  }

  public enum Handlers {
    public static let min =
      Specifications.handler(using: {
        Swift.min($0, $1)
      })

    public static let max =
      Specifications.handler(using: {
        Swift.max($0, $1)
      })
  }

  public enum Developer {
    @Sendable
    public static func memoryWithin(_ parameters: any CalculationParameters) -> Int {
      parameters.indexFor(value: 8 * .bytesPerGB)
    }

    @Sendable
    public static func cpuWithin(_ parameters: any CalculationParameters) -> Int {
      let valueRange = parameters.valueRange.clamped(to: 2 ... parameters.valueRange.upperBound - 2)
      let value = valueRange.clamped(to: 2 ... 6).upperBound
      return parameters.indexFor(value: value)
    }
  }
}
