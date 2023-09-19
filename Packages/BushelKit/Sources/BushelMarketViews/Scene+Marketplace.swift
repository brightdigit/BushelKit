//
// Scene+Marketplace.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelMarketEnvironment
  import BushelMarketStore
  import SwiftUI

  public extension Scene {
    func marketplace(
      onChangeOf scenePhase: ScenePhase,
      for groupIDs: [String] = [Configuration.Marketplace.groupID]
    ) -> some Scene {
      self.marketplace(for: groupIDs, listener: StoreListener(), onChangeOf: scenePhase)
    }
  }
#endif
