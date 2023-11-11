//
// WelcomeView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelLogging
  import BushelOnboardingEnvironment
  import BushelViewsCore
  import SwiftUI

  struct WelcomeView: SingleWindowView, LoggerCategorized {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openWindow) var openWindow
    @Environment(\.onboardingWindow) var onboardingWindow
    @AppStorage(for: RecentDocumentsClearDate.self) private var recentDocumentsClearDate
    @AppStorage(for: OnboardingAlphaAt.self) private var onboardedAt
    var body: some View {
      HStack {
        WelcomeTitleView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(
            colorScheme == .dark ?
              Color.black.opacity(0.35) :
              Color.white
          )

        WelcomeRecentDocumentsView(recentDocumentsClearDate: recentDocumentsClearDate).frame(width: 280)
      }
      .accessibilityElement(children: .contain)
      .accessibilityLabel("Welcome View")
      .frame(width: 750, height: 440)
      .task {
        do {
          try await Task.sleep(for: .seconds(0.5), tolerance: .seconds(0.25))
        } catch {
          Self.logger.error("Unable to wait for task")
          return
        }
        if onboardedAt == nil, !EnvironmentConfiguration.shared.skipOnboarding {
          Self.logger.debug("not onboarded, opening onboarding window")
          openWindow(value: onboardingWindow)
        }
      }
      .navigationTitle("Welcome to Bushel")
      .accessibilityIdentifier("welcomeView")
    }

    init() {}
  }

  #Preview {
    WelcomeView()
  }
#endif
