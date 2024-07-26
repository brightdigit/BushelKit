//
// Subscription.Offer.Kind.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(StoreKit)
  import BushelCore

  public import BushelLogging

  public import BushelMarket
  import Foundation

  public import StoreKit

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
