//
// CalculationParameters.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore

struct SpecificationCalculationParameters: CalculationParameters {
  internal let indexRange: ClosedRange<Int>
  internal let valueRange: ClosedRange<Int>
  private let indexForValue: @Sendable (Int) -> Int

  internal init(
    indexRange: ClosedRange<Int>,
    valueRange: ClosedRange<Int>,
    indexForValue: @escaping @Sendable (Int) -> Int
  ) {
    self.indexRange = indexRange
    self.valueRange = valueRange
    self.indexForValue = indexForValue
  }

  internal init(
    indexRange: ClosedRange<Float>,
    valueRange: ClosedRange<Float>,
    indexForValue: @escaping @Sendable (Int) -> Int
  ) {
    self.init(
      indexRange: .init(floatRange: indexRange),
      valueRange: .init(floatRange: valueRange),
      indexForValue: indexForValue
    )
  }

  func indexFor(value: Int) -> Int {
    indexForValue(value)
  }
}

public protocol CalculationParameters: Sendable {
  var indexRange: ClosedRange<Int> { get }
  var valueRange: ClosedRange<Int> { get }
  func indexFor(value: Int) -> Int
}

public extension CalculationParameters {
  func value(using closure: @escaping @Sendable (Int, Int) -> Int) -> Int {
    closure(indexRange.lowerBound, indexRange.upperBound)
  }
}
