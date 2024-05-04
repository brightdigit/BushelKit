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

  public extension EnvironmentValues {
    var purchaseWindow: PurchaseWindowValue {
      get { self[PurchaseWindowValueKey.self] }
      set { self[PurchaseWindowValueKey.self] = newValue }
    }
  }

  public extension Scene {
    func purchaseWindow(
      _ value: PurchaseWindowValue
    ) -> some Scene {
      self.environment(\.purchaseWindow, value)
    }
  }
#endif
