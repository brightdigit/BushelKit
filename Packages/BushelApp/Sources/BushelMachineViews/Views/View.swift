//
// View.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import BushelMarket
  import BushelViewsCore
  import Foundation
  import SwiftUI

  extension View {
    func alertForSnapshotLimit(
      isPresented: Binding<Bool>,
      open openWindow: OpenWindowAction,
      purchaseWindow: PurchaseWindowValue
    ) -> some View {
      self.alert(
        Text(LocalizedStringID.snapshotLimitTitle),
        isPresented: isPresented,
        actions: {
          Button(role: .cancel, .cancel) {}
          Button(LocalizedStringID.snapshotLimitUpgradeButton) {
            openWindow(value: purchaseWindow)
          }
        },
        message: {
          Text(.snapshotLimitMessage)
        }
      )
    }
  }
#endif
