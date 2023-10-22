//
// DebuggingView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLogging
  import BushelOnboardingEnvironment
  import StoreKit
  import SwiftUI

  struct DebuggingView<PurchaseScreenValue: Codable & Hashable>: View, LoggerCategorized {
    @Environment(\.openWindow) var openWindow
    @Environment(\.requestReview) var requestReview
    @Environment(\.onboardingWindow) var onboardingWindow
    let purchaseScreenValue: PurchaseScreenValue

    var body: some View {
      VStack {
        Button("Onboarding Screen") {
          self.openWindow(value: onboardingWindow)
        }

        Button("Review Request") {
          requestReview()
        }

        Button("Purchase Screen") {
          openWindow(value: purchaseScreenValue)
        }

        Button("Reset UserDefaults") {
          guard let domainName = Bundle.main.bundleIdentifier else {
            Self.logger.error("Couldn't find domain name or bundleIdentifier to clear.")
            return
          }
          UserDefaults.standard.removePersistentDomain(forName: domainName)
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
