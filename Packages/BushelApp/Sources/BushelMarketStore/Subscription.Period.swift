//
// Subscription.Period.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(StoreKit)
  import BushelCore

  public import BushelLogging

  public import BushelMarket
  import Foundation

  public import StoreKit

  extension Subscription.Period {
    public init?(subscription: Product.SubscriptionPeriod) {
      self.init(unit: .init(subscription.unit), value: subscription.value)
    }
  }
#endif
