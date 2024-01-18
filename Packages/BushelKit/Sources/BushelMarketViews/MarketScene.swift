//
// MarketScene.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLogging
  import Foundation
  import SwiftData
  import SwiftUI

  public struct MarketScene: Scene {
    public static var purchaseScreenValue: PurchaseView.Value {
      .default
    }

    public var body: some Scene {
      WindowGroup(singleOf: PurchaseView.self)
      #if os(macOS)
        .windowStyle(.hiddenTitleBar)
      #endif
        .windowResizability(.contentSize)
    }

    public init() {}
  }
#endif
