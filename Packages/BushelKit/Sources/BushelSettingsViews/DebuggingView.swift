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
          do {
            try Bundle.main.clearUserDefaults()
          } catch is Bundle.MissingIdentifierError {
            Self.logger.error("Couldn't find domain name or bundleIdentifier to clear.")
            assertionFailure("Couldn't find domain name or bundleIdentifier to clear.")
          } catch {
            Self.logger.critical("Unknown error: \(error)")
            assertionFailure("CUnknown error: \(error)")
          }
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
