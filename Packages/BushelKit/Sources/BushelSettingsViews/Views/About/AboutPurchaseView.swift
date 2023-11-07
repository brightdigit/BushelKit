//
// AboutPurchaseView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct AboutPurchaseView<PurchaseScreenValue: Codable & Hashable>: View {
    @Environment(\.openWindow) var openWindow
    let subscriptionEndDate: Date?
    let purchaseScreenValue: PurchaseScreenValue
    var body: some View {
      VStack(alignment: .leading) {
        if let subscriptionEndDate, subscriptionEndDate > .init() {
          Text(.aboutSubscriptionEndsAt).font(.system(.caption))
          Text(subscriptionEndDate, style: .date)
        } else {
          Button(.upgradePurchase) {
            openWindow(value: purchaseScreenValue)
          }.buttonStyle(.borderedProminent).fontWeight(.bold)
          Text(.proFeatures)
            .fontWeight(.thin)
            .lineLimit(2, reservesSpace: true)
        }
      }
    }
  }

#endif
