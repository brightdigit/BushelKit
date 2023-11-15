//
// AboutView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelLocalization
  import BushelMarketEnvironment
  import BushelViewsCore
  import SwiftUI

  struct AboutView<PurchaseScreenValue: Codable & Hashable>: View {
    @Environment(\.openWindow) var openWindow
    @Environment(\.openURL) var openURL

    let version: Version
    let subscriptionEndDate: Date?
    let purchaseScreenValue: PurchaseScreenValue

    var body: some View {
      VStack(alignment: .leading, spacing: 24) {
        AboutProductView(
          version: version,
          subscriptionEndDate: subscriptionEndDate,
          purchaseScreenValue: purchaseScreenValue
        )
        Divider()
        AboutFeedbackView(buttonURL: .bushel.contactMailTo)
        Divider()
        AboutBrandView(websiteURL: .bushel.company) {
          SocialLink.podcast
          SocialLink.youtube
          SocialLink.github
          SocialLink.linkedin
          SocialLink.twitter
          SocialLink.mastodon
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
