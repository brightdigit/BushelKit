//
// DebuggingView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import StoreKit
  import SwiftUI

  struct DebuggingView<PurchaseScreenValue: Codable & Hashable>: View {
    @Environment(\.openWindow) var openWindow
    @Environment(\.requestReview) var requestReview
    let purchaseScreenValue: PurchaseScreenValue

    var body: some View {
      VStack {
        Button("Onboarding Screen") {}

        Button("Review Request") {
          requestReview()
        }

        Button("Purchase Screen") {
          openWindow(value: purchaseScreenValue)
        }
      }.padding(20.0)
    }

    init(purchaseScreenValue: PurchaseScreenValue) {
      self.purchaseScreenValue = purchaseScreenValue
    }
  }

  #Preview {
    DebuggingView(purchaseScreenValue: 0)
  }
#endif
