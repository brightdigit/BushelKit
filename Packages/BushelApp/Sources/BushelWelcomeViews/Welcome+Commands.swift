//
// Welcome+Commands.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelData
  import BushelFeedbackEnvironment
  import BushelLocalization
  import BushelViewsCore
  import BushelWishListEnvironment
  import StoreKit
  import SwiftData

  public import SwiftUI

  public enum Welcome {
    public struct HelpCommands: View {
      public init() {}

      @Environment(\.openURL) private var openURL
      @Environment(\.openWindow) private var openWindow
      @Environment(\.onboardingWindow) private var onboardingWindow
      @Environment(\.userFeedback) private var userFeedbackEnabled
      @Environment(\.provideFeedback) private var provideFeedback
      @Environment(\.requestReview) private var requestReview
      @Environment(\.wishList) private var wishList

      @AppStorage(for: Tracking.Error.self)
      var errorTrackingEnabled

      public var body: some View {
        Group {
          Button(.whatsNew) {
            openWindow(value: onboardingWindow)
          }
          Button(openURL, URL.bushel.contactMailTo) {
            Text(.contactUs)
          }
          Button(.requestReview) {
            requestReview()
          }
          if userFeedbackEnabled.value, errorTrackingEnabled {
            Button(.menuProvideFeedback) {
              openWindow(value: provideFeedback)
            }
          }
          Button(.menuWishList) {
            openWindow(value: wishList)
          }
          Divider()
          Button(openURL, URL.bushel.support) {
            Text(.menuHelpBushel)
          }
        }
      }
    }

    public struct WindowCommands: View {
      public init() {}

      @Environment(\.openWindow) private var openWindow
      public var body: some View {
        Button(.welcomeToBushel) {
          openWindow(value: WelcomeView.Value.default)
        }
      }
    }

    public struct OpenCommands: View {
      public init() {}

      @Environment(\.openWindow) private var openWindow
      @Environment(\.openFileURL) private var openFileURL
      @Environment(\.allowedOpenFileTypes) private var allowedOpenFileTypes

      public var body: some View {
        Button(.menuOpen) {
          openFileURL(ofFileTypes: allowedOpenFileTypes, using: openWindow)
        }
        RecentDocumentsMenu()
      }
    }
  }
#endif
