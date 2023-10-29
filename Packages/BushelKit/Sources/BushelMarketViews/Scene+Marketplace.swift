//
// Scene+Marketplace.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelMarket
  import BushelMarketEnvironment
  import BushelMarketStore
  import SwiftUI

  public extension Scene {
    func marketplace(
      onChangeOf scenePhase: ScenePhase,
      for groupIDs: [String] = MarketplaceSettings.default.groupIDs
    ) -> some Scene {
      self.marketplace(for: groupIDs, listener: StoreListener(), onChangeOf: scenePhase)
    }
  }
#endif
