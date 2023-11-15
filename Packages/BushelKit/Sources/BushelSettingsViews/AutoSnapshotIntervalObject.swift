//
// AutoSnapshotIntervalObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import BushelViewsCore
  import Foundation
  import SwiftUI

  typealias AutoSnapshotIntervalObject = TransformedValueObject<Double, TimeInterval, DateComponents>

  extension AutoSnapshotIntervalObject {
    convenience init(inputValue: Double = 1.0) {
      self.init(
        defaultTransform: Self.transform(forPolynomial: .default),
        formattable: DateComponents.init(fromSeconds:),
        inputValue: inputValue
      )
    }

    static func transform(forPolynomial polynomial: LagrangePolynomial) -> (InputValue) -> (OutputValue) {
      { value in
        polynomial.transform(value).roundToNearest(value: .Snapshot.intervalIncrements)
      }
    }

    func bindTo(_ bindingValue: Binding<Int?>, using polynomial: LagrangePolynomial) {
      self.bindTo(
        bindingValue.map(
          to: { $0.map(Double.init) },
          from: { $0.map(Int.init) }
        ),
        using: Self.transform(forPolynomial: polynomial)
      )
    }
  }
#endif
