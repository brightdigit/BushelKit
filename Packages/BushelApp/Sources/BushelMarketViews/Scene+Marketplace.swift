//
// Scene+Marketplace.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore

  public import BushelMarket
  import BushelMarketEnvironment
  import BushelMarketStore

  public import SwiftUI

  extension Scene {
    @MainActor
    public func marketplace(
      onChangeOf scenePhase: ScenePhase,
      for groupIDs: [String] = MarketplaceSettings.default.groupIDs
    ) -> some Scene {
      self.marketplace(for: groupIDs, listener: StoreListener(), onChangeOf: scenePhase)
    }
  }
#endif
