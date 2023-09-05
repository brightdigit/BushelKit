//
// PreferencesView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import StoreKit
  import SwiftUI

  public struct PreferencesView: View {
    public init() {}
    private enum Tabs: Hashable {
      case general, advanced, tests
    }

    public var body: some View {
      TabView {
        Text(.generalSettings)
          .tabItem {
            Label("General", systemImage: "gear")
          }
          .tag(Tabs.general)
        AdvancedSettingsView()
          .tabItem {
            Label("Advanced", systemImage: "star")
          }
          .tag(Tabs.advanced)
        VStack {
          Button("Onboarding Screen") {
//            Windows.openWindow(withHandle: BasicWindowOpenHandle.onboarding)
          }

          Button("Review Request") {
            SKStoreReviewController.requestReview()
          }

          Button("Purchase Screen") {
//            Windows.openWindow(withHandle: BasicWindowOpenHandle.purchase)
          }
        }
        .padding(20.0)
        .tabItem {
          Label("Test Panel", systemImage: "capsule.portrait.bottomhalf.filled")
        }
        .tag(Tabs.tests)
      }
      .padding(20)
      .frame(width: 375, height: 150)
    }
  }

  #Preview() {
    PreferencesView()
  }

  public extension Settings {
    init() where Content == PreferencesView {
      self.init {
        PreferencesView()
      }
    }
  }
#endif
