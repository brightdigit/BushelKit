//
// Subscription.Period.Unit.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(StoreKit)
  import BushelCore
  import BushelLogging
  import BushelMarket
  import Foundation
  import StoreKit

  public extension Subscription.Period.Unit {
    init(_ unit: Product.SubscriptionPeriod.Unit) {
      switch unit {
      case .day:
        self = .day

      case .week:
        self = .week

      case .month:
        self = .month

      case .year:
        self = .year
      @unknown default:
        assertionFailure("Unknown unit: \(unit)")
        self = .unknown(value: unit)
      }
    }
  }
#endif
