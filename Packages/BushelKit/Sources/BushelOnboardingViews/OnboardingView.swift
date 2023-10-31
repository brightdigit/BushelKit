//
// OnboardingView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLogging
  import BushelOnboardingCore
  import BushelViewsCore
  import SwiftUI

  public struct OnboardingView: SingleWindowView, LoggerCategorized {
    public typealias Value = OnboardingWindowValue
    @AppStorage(for: OnboardingAlphaAt.self) private var onboardedAt: Date?
    @State var windowInitialized = false

    #warning("shendy-note: this might need to have adaptive frame to screen size")
    public var body: some View {
      PageView(onDismiss: self.onDismiss) {
        WelcomePageView()
        FeaureListView()
        LibraryPageView()
        HubPageView()
        MachinePageView()
        SnapshotsPageView()
        DonePageView()
      }
      .frame(width: 700, height: 700)
      .nsWindowAdaptor(self.setupNSWindow(_:))
    }

    public init() {}

    private func onDismiss() {
      self.onboardedAt = Date()
      Self.logger.debug("Completed Onboarding")
    }

    #if os(macOS)
      private func setupNSWindow(_ window: NSWindow?) {
        guard let window, !windowInitialized else {
          return
        }
        window.standardWindowButton(.closeButton)?.superview?.isHidden = true
        window.titlebarAppearsTransparent = true
        window.level = .floating
        windowInitialized = true
        Self.logger.debug("Completed Window Initialization.")
      }
    #else
      private func setupNSWindow(_: Any?) {}
    #endif
  }

  #Preview {
    OnboardingView()
  }
#endif