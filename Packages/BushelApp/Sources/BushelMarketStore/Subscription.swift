//
// Subscription.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(StoreKit)
  import BushelCore
  import BushelLogging
  import BushelMarket
  import Foundation
  import StoreKit

  public extension Subscription {
    init?(transaction: Transaction) async {
      let renewalInfo = try? await transaction.subscriptionStatus?.renewalInfo.payloadValue
      let groupID = transaction.subscriptionGroupID

      guard let groupID, transaction.revocationDate == nil else {
        return nil
      }

      self.init(
        groupID: groupID,
        currentProductID: transaction.productID,
        transactionDate: transaction.signedDate,
        environment: .init(transaction.environment),
        willAutoRenew: renewalInfo?.willAutoRenew,
        recentSubscriptionStartDate: renewalInfo?.recentSubscriptionStartDate ?? transaction.purchaseDate,
        renewalDate: renewalInfo?.renewalDate ?? transaction.expirationDate
      )
    }

    init(
      groupID: String,
      renewal: Product.SubscriptionInfo.RenewalInfo,
      products: [Product.ID: Product],
      transactionDate: Date = .init()
    ) {
      let product = products[renewal.currentProductID]
      let subscriptionPeriod = product?.subscription?.subscriptionPeriod

      self.init(
        groupID: groupID,
        currentProductID: renewal.currentProductID,
        transactionDate: transactionDate,
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
