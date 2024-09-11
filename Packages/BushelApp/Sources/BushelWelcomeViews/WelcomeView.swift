//
// WelcomeView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelAccessibility
  import BushelCore
  import BushelLocalization
  import BushelLogging
  import BushelMessage
  import BushelOnboardingEnvironment
  import BushelSessionEnvironment
  import RadiantKit
  import SwiftUI

  internal struct WelcomeView: SingleWindowView, Loggable {
    @Environment(\.session) var session
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openWindow) var openWindow
    @Environment(\.onboardingWindow) var onboardingWindow
    @AppStorage(for: RecentDocuments.TypeFilter.self) private var recentDocumentsTypeFilter
    @AppStorage(for: RecentDocuments.ClearDate.self) private var recentDocumentsClearDate
    @AppStorage(for: Onboarding.Fuji.self) private var onboardedAt
    var body: some View {
      HStack {
        WelcomeTitleView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(
            colorScheme == .dark ?
              Color.black.opacity(0.35) :
              Color.white
          )

        WelcomeRecentDocumentsView(
          recentDocumentsTypeFilter: recentDocumentsTypeFilter,
          recentDocumentsClearDate: recentDocumentsClearDate
        )
        .frame(width: 280)
      }
      .frame(width: 750, height: 440)
      .navigationTitle(Text(.welcomeToBushel))
      .onAppear(perform: {
        Task {
          do {
            let result = try await self.session.sendMessage(MachineNameListRequest())
            print("count", result)
          } catch {
            dump(error)
          }
        }
      })
      .task {
        do {
          try await Task.sleep(for: .seconds(0.5), tolerance: .seconds(0.25))
        } catch {
          Self.logger.error("Unable to wait for task")
          return
        }
        if EnvironmentConfiguration.shared.onboardingOveride.shouldBasedOn(date: self.onboardedAt) {
          Self.logger.debug("not onboarded, opening onboarding window")
          openWindow(value: onboardingWindow)
        }
      }
    }

    init() {}
  }

  #Preview {
    WelcomeView()
  }
#endif
