//
// MockCalculationParameters.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelFactory

internal struct MockCalculationParameters: CalculationParameters {
  let expectedIndex: Int
  let indexRange: ClosedRange<Int>

  let valueRange: ClosedRange<Int>

  func indexFor(value _: Int) -> Int {
    expectedIndex
  }
}
