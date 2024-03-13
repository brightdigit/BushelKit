//
// Subscription+Offer.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

public extension Subscription {
  struct Offer: Sendable {
    public enum Kind: Sendable {
      case introductory

      case promotional

      case code

      case unknown(rawValue: Int)
    }

    public init(type: Subscription.Offer.Kind, id: String) {
      self.type = type
      self.id = id
    }

    public let type: Kind
    public let id: String
  }
}
