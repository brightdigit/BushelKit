//
// Double.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public extension Double {
  func transform(using polynomial: LagrangePolynomial) -> Double {
    polynomial.transform(self)
  }

  func roundToNearest(value: Double, unlessThan: Bool = true) -> Double {
    if self < value, unlessThan {
      return self
    }

    let quarterMinutes = (self / value).rounded()
    return quarterMinutes * value
  }
}
