//
// Subscription.Period.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(StoreKit)
  import BushelCore
  import BushelLogging
  import BushelMarket
  import Foundation
  import StoreKit

  extension Subscription.Period {
    public init?(subscription: Product.SubscriptionPeriod) {
      self.init(unit: .init(subscription.unit), value: subscription.value)
    }
  }
#endif
