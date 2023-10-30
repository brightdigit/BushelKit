//
// WelcomeLogoTitleLabelView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLocalization
  import BushelMarketEnvironment
  import SwiftUI

  struct WelcomeLogoTitleLabelView: View {
    @Environment(\.marketplace) var marketplace
    var body: some View {
      HStack {
        Text(.welcomeToBushel)
          .font(.system(size: 36.0))
          .fontWeight(.bold)

        if (marketplace.subscriptionEndDate ?? .distantPast) > .now {
          Text(.welcomePro)
            .font(.system(size: 36.0))
            .fontWeight(.bold)
            .foregroundStyle(.tint)
            .italic()
        }
      }
      Text(
        .key(LocalizedStringID.version),
        .text(
          // swiftlint:disable:next line_length
          "\(Bundle.applicationVersionFormatted.marketingVersion) (\(Bundle.applicationVersionFormatted.buildNumberHex))"
        )
      )
      .font(.system(size: 12.0))
      .fontWeight(.medium)
      .foregroundColor(.secondary)
    }
  }

  #Preview {
    WelcomeLogoTitleLabelView()
  }
#endif
