//
// Subscription.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

public struct Subscription {
  public let groupID: String
  public let currentProductID: String
  public let environment: Environment
  public let willAutoRenew: Bool
  public let recentSubscriptionStartDate: Date
  public let renewalDate: Date?
  public let period: Subscription.Period?
  public let offer: Subscription.Offer?
  public let gracePeriodExpirationDate: Date?
  public let autoRenewPreference: String?
  public init(
    groupID: String,
    currentProductID: String,
    environment: Subscription.Environment,
    willAutoRenew: Bool,
    recentSubscriptionStartDate: Date,
    renewalDate: Date? = nil,
    period: Subscription.Period? = nil,
    offer: Subscription.Offer? = nil,
    gracePeriodExpirationDate: Date? = nil,
    autoRenewPreference: String? = nil
  ) {
    self.groupID = groupID
    self.currentProductID = currentProductID
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
