//
// Welcome+Commands.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelData
  import BushelLocalization
  import BushelViewsCore
  import SwiftData
  import SwiftUI

  public enum Welcome {
    public struct HelpCommands: View {
      public init() {}

      @Environment(\.openURL) private var openURL
      @Environment(\.openWindow) private var openWindow
      @Environment(\.onboardingWindow) private var onboardingWindow

      public var body: some View {
        Button(.menuOnboarding) {
          openWindow(value: onboardingWindow)
        }
        Button(openURL, URL.bushel.contactMailTo) {
          Text(.contactUs)
        }
        Divider()
        Button(openURL, URL.bushel.support) {
          Text(.menuHelpBushel)
        }
      }
    }

    public struct WindowCommands: View {
      public init() {}

      @Environment(\.openWindow) private var openWindow
      public var body: some View {
        Button("Welcome to Bushel") {
          openWindow(value: WelcomeView.Value.default)
        }
      }
    }

    public struct OpenCommands: View {
      public init() {}

      @AppStorage(for: RecentDocuments.TypeFilter.self) private var recentDocumentsTypeFilter
      @AppStorage(for: RecentDocuments.ClearDate.self) private var recentDocumentsClearDate
      @Environment(\.openWindow) private var openWindow
      @Environment(\.openFileURL) private var openFileURL
      @Environment(\.allowedOpenFileTypes) private var allowedOpenFileTypes

      public var body: some View {
        Button("Open...") {
          openFileURL(ofFileTypes: allowedOpenFileTypes, using: openWindow)
        }
        RecentDocumentsMenu(
          recentDocumentsClearDate: recentDocumentsClearDate,
          recentDocumentsTypeFilter: recentDocumentsTypeFilter
        ) {
          recentDocumentsClearDate = .init()
        }
      }
    }
  }
#endif
