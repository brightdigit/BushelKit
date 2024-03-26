//
// OnboardingView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLocalization
  import BushelLogging
  import BushelOnboardingCore
  import BushelViewsCore
  import SwiftUI

  public struct OnboardingView: SingleWindowView, Loggable {
    public typealias Value = OnboardingWindowValue
    @AppStorage(for: Onboarding.NorthernSpy.self) private var onboardedAt: Date?
    @State var windowInitialized = false

    #warning("shendy-note: this might need to have adaptive frame to screen size")
    public var body: some View {
      PageView(onDismiss: self.onDismiss) {
        PageItem.welcome
        FeatureList()
        PageItem.library
        PageItem.hub
        PageItem.machine
        PageItem.snapshots
        PageItem.done
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
        window.isRestorable = false
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
