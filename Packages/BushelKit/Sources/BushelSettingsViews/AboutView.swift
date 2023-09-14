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
                Text("Bushel").font(.system(size: 36)).fontWeight(.black)
                Text(
                  .text(
                    "\(version.description) (\(version.buildNumberHex(withLength: 3)))"
                  )
                ).font(.caption)
              }
              VStack(alignment: .leading) {
                if let subscriptionEndDate {
                  Text("PRO Subscription ends at:").font(.system(.caption))
                  Text(subscriptionEndDate, style: .date)
                } else {
                  Button("GO PRO") {}.buttonStyle(.borderedProminent).fontWeight(.bold)
                  Text("Proin scelerisque cursus lacus, consequat tincidunt ex portti.")
                    .font(.system(size: 11.0))
                }
              }
              Text("© BrightDigit, LLC 2023").font(.system(.caption))
            }.apply(\.size.height, with: value)
          }
        }
        Divider()
        VStack(alignment: .leading) {
          Text("Feedback & Issues").fontWeight(.bold)
          Text("Etiam non dictum nisi, in rhoncus nulla. Aenean eget nulla nec sem ultrices ornare vitae finibus ex. Maecenas hendrerit, felis.")
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

//  #Preview {
//    About
//    AboutView(shortVersion: "1.0.0", buildNumber: 42, subscriptionEndDate: nil, purchaseScreenValue: 0)
//  }
//
//  #Preview {
//    AboutView(shortVersion: "1.0.0", buildNumber: 42, subscriptionEndDate: .init(timeIntervalSinceNow: 1_000_000), purchaseScreenValue: 0)
//  }
#endif
