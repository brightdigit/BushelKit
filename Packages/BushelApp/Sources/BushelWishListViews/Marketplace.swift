//
// Marketplace.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMarketEnvironment
  import Foundation
  import WishKit

  extension Marketplace {
    var payment: Payment? {
      guard let subscriptions else {
        return nil
      }
      let values: [Int] = subscriptions.map { subscription -> Int in
        guard let period = subscription.period else {
          return 0
        }
        switch period.unit {
        case .month:
          return 11
        case .year:
          return 66
        default:
          assertionFailure("Unknown period unit: \(period.unit)")
          return 66
        }
      }

      let monthlyPayment: Decimal = .init(values.reduce(0, +))

      guard monthlyPayment > 0 else {
        return nil
      }

      return .monthly(monthlyPayment)
    }
  }
#endif
