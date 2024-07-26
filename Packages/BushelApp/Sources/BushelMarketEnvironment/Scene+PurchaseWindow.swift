//
// Scene+PurchaseWindow.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import BushelCore
  import BushelEnvironmentCore

  public import BushelMarket

  public import Foundation

  public import SwiftUI

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
