//
// Subscription.Environment.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(StoreKit)
  import BushelCore

  public import BushelLogging

  public import BushelMarket
  import Foundation

  public import StoreKit

  extension Subscription.Environment {
    public init(_ enviromnent: AppStore.Environment) {
      switch enviromnent {
      case .production:
        self = .production

      case .xcode:
        self = .xcode

      case .sandbox:
        self = .sandbox

      default:
        assertionFailure("Unknown environmment: \(enviromnent)")
        self = .unknown(rawValue: enviromnent.rawValue)
      }
    }
  }
#endif
