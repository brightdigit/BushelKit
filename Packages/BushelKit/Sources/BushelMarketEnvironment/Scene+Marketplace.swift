//
// Scene+Marketplace.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLogging
  import BushelMarket
  import Foundation
  import SwiftUI

  private struct MarketplaceKey: EnvironmentKey {
    static let defaultValue: Marketplace = .default
  }

  public extension EnvironmentValues {
    var marketplace: Marketplace {
      get { self[MarketplaceKey.self] }
      set {
        self[MarketplaceKey.self] = newValue
      }
    }
  }

  public extension Scene {
    func marketplace(
      for groupIDs: [String],
      listener: @autoclosure () -> MarketListener,
      onChangeOf scenePhase: ScenePhase
    ) -> some Scene {
      let marketplace = Marketplace.createFor(groupIDs: groupIDs, listener: listener())
      return self
        .environment(\.marketplace, marketplace)
        .onChange(of: scenePhase) { _, newValue in
          if newValue == .active {
            marketplace.beginUpdates()
          }
        }
    }
  }
#endif
