//
// ClosedRange.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public extension ClosedRange where Bound: Randomizable & AdditiveArithmetic {
  static func random(
    startingIn startingRange: ClosedRange<Bound>,
    withSizeWithin sizeRange: ClosedRange<Bound>
  ) -> Self {
    let lowerBound = Bound.random(in: startingRange)
    let upperBound = lowerBound + Bound.random(in: sizeRange)
    return .init(
      uncheckedBounds: (
        lower: lowerBound,
        upper: upperBound
      )
    )
  }
}
