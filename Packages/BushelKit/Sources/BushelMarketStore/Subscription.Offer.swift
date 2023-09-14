//
// Subscription.Offer.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(StoreKit)
  import BushelCore
  import BushelLogging
  import BushelMarket
  import Foundation
  import StoreKit

  public extension Subscription.Offer {
    init?(renewal: Product.SubscriptionInfo.RenewalInfo) {
      guard
        let type = renewal.offerType.flatMap(Subscription.Offer.Kind.init),
        let id = renewal.offerID else {
        return nil
      }
      self.init(type: type, id: id)
    }
  }
#endif
