//
//  ClosedRange.swift
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

extension ClosedRange where Bound == Int {
  /// Initializes a `ClosedRange<Int>` from a `ClosedRange<Float>`.
  ///
  /// - Parameter floatRange: The `ClosedRange<Float>` to be converted.
  public init(floatRange: ClosedRange<Float>) {
    let lowerBound = Int(floatRange.lowerBound.rounded(.up))
    let upperBound = Int(floatRange.upperBound.rounded(.down))
    self = lowerBound...upperBound
  }
}

extension ClosedRange where Bound == Float {
  /// Initializes a `ClosedRange<Float>` from a `ClosedRange<Int>`.
  ///
  /// - Parameter intRange: The `ClosedRange<Int>` to be converted.
  public init(intRange: ClosedRange<Int>) {
    let lowerBound = Float(intRange.lowerBound)
    let upperBound = Float(intRange.upperBound)
    self = lowerBound...upperBound
  }
}

extension ClosedRange where Bound: BinaryInteger {
  /// Expands the current `ClosedRange` by the given value.
  ///
  /// - Parameter value: The value to expand the range by.
  /// - Returns: A new `ClosedRange` that is expanded by the given value.
  public func expanded(by value: Bound) -> ClosedRange<Bound> {
    // Ensure the added value is odd
    let boundExpandSmaller = value / 2
    let boundExpandLarger = value - boundExpandSmaller

    let lowerBoundExpand = Bool.random() ? boundExpandLarger : boundExpandSmaller
    let upperBoundExpand = value - lowerBoundExpand

    let lowerBound = self.lowerBound - lowerBoundExpand
    let upperBound = self.upperBound + upperBoundExpand
    return lowerBound...upperBound
  }
}
