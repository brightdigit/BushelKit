//
// SettingsView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI) && canImport(StoreKit)
  import StoreKit
  import SwiftUI

  struct SettingsView: View {
    private enum Tabs: Hashable {
      case general, advanced, tests
    }

    var body: some View {
      TabView {
        Text(.generalSettings)
          .tabItem {
            Label("General", systemImage: "gear")
          }
          .tag(Tabs.general)
        Text(.advancedSettings)
          .tabItem {
            Label("Advanced", systemImage: "star")
          }
          .tag(Tabs.advanced)
        VStack {
          Button("Onboarding Screen") {
            Windows.openWindow(withHandle: BasicWindowOpenHandle.onboarding)
          }

          Button("Review Request") {
            SKStoreReviewController.requestReview()
          }

          Button("Purchase Screen") {
            Windows.openWindow(withHandle: BasicWindowOpenHandle.purchase)
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

  struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
      SettingsView()
    }
  }
#endif
