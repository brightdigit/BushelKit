//
// Subscription.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(StoreKit)
  import BushelCore
  import BushelLogging
  import BushelMarket
  import Foundation
  import StoreKit

  public extension Subscription {
    init(groupID: String, renewal: Product.SubscriptionInfo.RenewalInfo, products: [Product.ID: Product]) {
      let product = products[renewal.currentProductID]
      let subscriptionPeriod = product?.subscription?.subscriptionPeriod

      let currentProductID = renewal.currentProductID
      let productID = String(describing: product?.id)

      assert(
        subscriptionPeriod != nil,
        "Missing subscription period: \(currentProductID) \(productID)"
      )

      self.init(
        groupID: groupID,
        currentProductID: renewal.currentProductID,
        environment: .init(renewal.environment),
        willAutoRenew: renewal.willAutoRenew,
        recentSubscriptionStartDate: renewal.recentSubscriptionStartDate,
        renewalDate: renewal.renewalDate,
        period: subscriptionPeriod.flatMap(Period.init(subscription:)),
        offer: .init(renewal: renewal),
        gracePeriodExpirationDate: renewal.gracePeriodExpirationDate,
        autoRenewPreference: renewal.autoRenewPreference
      )
    }
  }
#endif
