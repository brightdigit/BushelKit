//
// Subscription.Period.Unit.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(StoreKit)
  import BushelCore

  public import BushelLogging

  public import BushelMarket
  import Foundation

  public import StoreKit

  extension Subscription.Period.Unit {
    public init(_ unit: Product.SubscriptionPeriod.Unit) {
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
