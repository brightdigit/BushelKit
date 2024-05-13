//
// Subscription.Offer.Kind.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(StoreKit)
  import BushelCore
  import BushelLogging
  import BushelMarket
  import Foundation
  import StoreKit

  extension Subscription.Offer.Kind {
    public init(_ type: StoreKit.Transaction.OfferType) {
      switch type {
      case .code:
        self = .code

      case .introductory:
        self = .introductory

      case .promotional:
        self = .promotional

      default:
        assertionFailure("Unknown offer type: \(type)")
        self = .unknown(rawValue: type.rawValue)
      }
    }
  }
#endif
