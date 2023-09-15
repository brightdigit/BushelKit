//
// AboutView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLocalization
  import BushelMarketEnvironment
  import BushelViewsCore
  import SwiftUI

  struct AboutView<PurchaseScreenValue: Codable & Hashable>: View {
    @Environment(\.openWindow) var openWindow

    let version: Version
    let subscriptionEndDate: Date?
    let purchaseScreenValue: PurchaseScreenValue

    var body: some View {
      VStack(alignment: .leading, spacing: 24) {
        PreferredLayoutView { value in
          HStack(spacing: 40) {
            Image
              .resource("Logo")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: value.get())
            VStack(alignment: .leading, spacing: 16) {
              VStack(alignment: .leading) {
                Text(.welcomeToBushel).font(.system(size: 36)).fontWeight(.black)
                Text(
                  .text(
                    "\(version.description) (\(version.buildNumberHex(withLength: 3)))"
                  )
                ).font(.caption)
              }
              VStack(alignment: .leading) {
                if let subscriptionEndDate {
                  Text(.aboutSubscriptionEndsAt).font(.system(.caption))
                  Text(subscriptionEndDate, style: .date)
                } else {
                  Button(.upgradePurchase) {
                    openWindow(value: purchaseScreenValue)
                  }.buttonStyle(.borderedProminent).fontWeight(.bold)
                  Text(.proFeatures)
                    .font(.system(size: 11.0))
                }
              }
              Text(.copyrightBrightdigit).font(.system(.caption))
            }.apply(\.size.height, with: value)
          }
        }
        Divider()
        VStack(alignment: .leading) {
          Text(.aboutFeedback).fontWeight(.bold)
          Text(.aboutFeedbackDetails)
        }
        Spacer()
      }

      .padding(20.0)
    }

    internal init(version: Version, subscriptionEndDate: Date?, purchaseScreenValue: PurchaseScreenValue) {
      self.version = version
      self.subscriptionEndDate = subscriptionEndDate
      self.purchaseScreenValue = purchaseScreenValue
    }
  }
#endif
