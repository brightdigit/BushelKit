//
// Scene+PurchaseWindow.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelEnvironmentCore
  import BushelMarket
  import Foundation
  import SwiftUI

  private struct PurchaseWindowValueKey: EnvironmentKey {
    typealias Value = PurchaseWindowValue
  }

  extension PurchaseWindowValue: DefaultableViewValue {}

  extension EnvironmentValues {
    public var purchaseWindow: PurchaseWindowValue {
      get { self[PurchaseWindowValueKey.self] }
      set { self[PurchaseWindowValueKey.self] = newValue }
    }
  }

  extension Scene {
    public func purchaseWindow(
      _ value: PurchaseWindowValue
    ) -> some Scene {
      self.environment(\.purchaseWindow, value)
    }
  }
#endif
