//
// Scene+Marketplace.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import BushelCore

  public import BushelLogging

  public import BushelMarket

  public import Foundation

  public import SwiftUI

  private struct MarketplaceKey: EnvironmentKey {
    static let defaultValue: Marketplace = .default
  }

  extension EnvironmentValues {
    public var marketplace: Marketplace {
      get { self[MarketplaceKey.self] }
      set {
        self[MarketplaceKey.self] = newValue
      }
    }
  }

  extension Scene {
    @MainActor
    public func marketplace(
      for groupIDs: [String],
      listener: @autoclosure @Sendable @escaping () -> any MarketListener,
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
