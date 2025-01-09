//
//  CalculationParameters.swift
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

internal struct SpecificationCalculationParameters: CalculationParameters {
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

  internal func indexFor(value: Int) -> Int {
    indexForValue(value)
  }
}

public protocol CalculationParameters: Sendable {
  var indexRange: ClosedRange<Int> { get }
  var valueRange: ClosedRange<Int> { get }
  func indexFor(value: Int) -> Int
}

extension CalculationParameters {
  public func value(using closure: @escaping @Sendable (Int, Int) -> Int) -> Int {
    closure(indexRange.lowerBound, indexRange.upperBound)
  }
}
