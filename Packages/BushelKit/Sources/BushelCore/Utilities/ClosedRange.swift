//
// ClosedRange.swift
// Copyright (c) 2024 BrightDigit.
//

public extension ClosedRange where Bound == Int {
  init(floatRange: ClosedRange<Float>) {
    let lowerBound = Int(floatRange.lowerBound.rounded(.up))
    let upperBound = Int(floatRange.upperBound.rounded(.down))
    self = lowerBound ... upperBound
  }
}

public extension ClosedRange where Bound == Float {
  init(intRange: ClosedRange<Int>) {
    let lowerBound = Float(intRange.lowerBound)
    let upperBound = Float(intRange.upperBound)
    self = lowerBound ... upperBound
  }
}

public extension ClosedRange where Bound: BinaryInteger {
  func expanded(by value: Bound) -> ClosedRange<Bound> {
    // Ensure the added value is odd

    let boundExpandSmaller = value / 2
    let boundExpandLarger = value - boundExpandSmaller

    let lowerBoundExpand = Bool.random() ? boundExpandLarger : boundExpandSmaller
    let upperBoundExpand = value - lowerBoundExpand

    let lowerBound = self.lowerBound - lowerBoundExpand
    let upperBound = self.upperBound + upperBoundExpand
    return lowerBound ... upperBound
  }
}
