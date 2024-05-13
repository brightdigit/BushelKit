//
// MarketUserCipher.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import BushelCore
  import Foundation

  @available(*, deprecated)
  public actor MarketUserCipher {
    public static let shared = MarketUserCipher()
    private var marketplace: Marketplace?

    public static func updateMarketplace(_ marketplace: Marketplace) {
      Task {
        await shared.updateMarketplace(marketplace)
      }
    }

    private func updateMarketplace(_ marketplace: Marketplace) async {
      self.marketplace = marketplace
    }

    public func includes(_ userType: BushelCore.UserAudience) async -> Bool {
      assert(marketplace != nil)
      let proSubscriber = marketplace?.purchased ?? false

      let testFlightBeta = Bundle.applicationVersion.prereleaseLabel != nil

      var currentInstance: UserAudience = []

      if proSubscriber {
        currentInstance.formUnion(.proSubscriber)
      }

      if testFlightBeta {
        currentInstance.formUnion(.testFlightBeta)
      }

      return !(currentInstance.isDisjoint(with: userType))
    }
  }
#endif
