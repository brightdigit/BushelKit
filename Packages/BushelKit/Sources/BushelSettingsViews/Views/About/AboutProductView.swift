//
// AboutProductView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelViewsCore
  import SwiftUI

  struct AboutProductView<PurchaseScreenValue: Codable & Hashable>: View {
    let version: Version
    let subscriptionEndDate: Date?
    let purchaseScreenValue: PurchaseScreenValue

    var body: some View {
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
            AboutPurchaseView(
              subscriptionEndDate: subscriptionEndDate,
              purchaseScreenValue: purchaseScreenValue
            )
            Text(.copyrightBrightdigit).font(.system(.caption))
          }.apply(\.size.height, with: value)
        }
      }
    }
  }
#endif
