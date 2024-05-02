//
// Subscription.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct Subscription: Sendable {
  public let groupID: String
  public let currentProductID: String
  public let transcationDate: Date
  public let environment: Environment
  // swiftlint:disable:next discouraged_optional_boolean
  public let willAutoRenew: Bool?
  public let recentSubscriptionStartDate: Date
  public let renewalDate: Date?
  public let period: Subscription.Period?
  public let offer: Subscription.Offer?
  public let gracePeriodExpirationDate: Date?
  public let autoRenewPreference: String?
  public init(
    groupID: String,
    currentProductID: String,
    transactionDate: Date,
    environment: Subscription.Environment,
    // swiftlint:disable:next discouraged_optional_boolean
    willAutoRenew: Bool?,
    recentSubscriptionStartDate: Date,
    renewalDate: Date? = nil,
    period: Subscription.Period? = nil,
    offer: Subscription.Offer? = nil,
    gracePeriodExpirationDate: Date? = nil,
    autoRenewPreference: String? = nil
  ) {
    self.groupID = groupID
    self.currentProductID = currentProductID
    self.transcationDate = transactionDate
    self.environment = environment
    self.willAutoRenew = willAutoRenew
    self.recentSubscriptionStartDate = recentSubscriptionStartDate
    self.renewalDate = renewalDate
    self.period = period
    self.offer = offer
    self.gracePeriodExpirationDate = gracePeriodExpirationDate
    self.autoRenewPreference = autoRenewPreference
  }
}

public extension Optional where Wrapped == [Subscription] {
  mutating func merge(with updatedSubscriptions: [Subscription]) {
    guard let oldSubscriptions = self else {
      self = updatedSubscriptions
      return
    }

    let productSubscriptions = Dictionary(
      grouping: oldSubscriptions + updatedSubscriptions
    ) {
      $0.currentProductID
    }
    let values = productSubscriptions.compactMapValues { subscriptions in
      subscriptions.max(by: {
        $0.transcationDate < $1.transcationDate
      })
    }.values

    self = .some(.init(values))
  }
}
