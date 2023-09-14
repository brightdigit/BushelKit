//
// Subscription.Period.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(StoreKit)
  import BushelCore
  import BushelLogging
  import BushelMarket
  import Foundation
  import StoreKit

  public extension Subscription.Period {
    init?(subscription: Product.SubscriptionPeriod) {
      self.init(unit: .init(subscription.unit), value: subscription.value)
    }
  }
#endif
