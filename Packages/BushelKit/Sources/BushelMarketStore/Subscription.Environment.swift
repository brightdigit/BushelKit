//
// Subscription.Environment.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(StoreKit)
  import BushelCore
  import BushelLogging
  import BushelMarket
  import Foundation
  import StoreKit

  public extension Subscription.Environment {
    init(_ enviromnent: AppStore.Environment) {
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
