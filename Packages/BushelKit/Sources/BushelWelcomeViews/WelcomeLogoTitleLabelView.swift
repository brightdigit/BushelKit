//
// WelcomeLogoTitleLabelView.swift
// Copyright (c) 2024 BrightDigit.
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
        Text(.bushel)
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

      HStack(spacing: 4) {
        Text(.version)
        Text(
          // swiftlint:disable:next line_length
          "\(Bundle.applicationVersionFormatted.marketingVersion) (\(Bundle.applicationVersionFormatted.buildNumberHex))"
        )
      }
      .font(.system(size: 12.0))
      .fontWeight(.medium)
      .foregroundColor(.secondary)
    }
  }

  #Preview {
    WelcomeLogoTitleLabelView()
  }
#endif
