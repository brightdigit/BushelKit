//
// Subscription.Offer.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(StoreKit)
  import BushelCore
  import BushelLogging
  import BushelMarket
  import Foundation
  import StoreKit

  extension Subscription.Offer {
    public init?(renewal: Product.SubscriptionInfo.RenewalInfo) {
      guard
        let type = renewal.offerType.flatMap(Subscription.Offer.Kind.init),
        let id = renewal.offerID else {
        return nil
      }
      self.init(type: type, id: id)
    }
  }
#endif
