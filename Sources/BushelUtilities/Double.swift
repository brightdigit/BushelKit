//
//  Double.swift
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

internal import Foundation

extension Double {
  /// Transforms the current `Double` value using the provided `LagrangePolynomial`.
  /// - Parameter polynomial: The `LagrangePolynomial` to use for the transformation.
  /// - Returns: The transformed `Double` value.
  public func transform(using polynomial: LagrangePolynomial) -> Double {
    polynomial.transform(self)
  }

  /// Rounds the current `Double` value to the nearest multiple of the provided `value`.
  /// - Parameter value: The value to round to.
  /// - Parameter unlessThan: A boolean that determines whether the current value
  /// should be returned if it is less than the provided `value`. Defaults to `true`.
  /// - Returns: The rounded `Double` value.
  public func roundToNearest(value: Double, unlessThan: Bool = true) -> Double {
    if self < value, unlessThan {
      return self
    }

    let quarterMinutes = (self / value).rounded()
    return quarterMinutes * value
  }
}
