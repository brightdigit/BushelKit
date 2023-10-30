//
// PreferencesView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelLocalization
  import BushelMarketEnvironment
  import StoreKit
  import SwiftUI

  public struct PreferencesView<PurchaseScreenValue: Codable & Hashable>:
    View {
    private enum Tabs: Hashable {
      case general, advanced, tests, about
    }

    @Environment(\.openWindow) var openWindow
    @Environment(\.marketplace) var marketplace

    let purchaseScreenValue: PurchaseScreenValue

    public var body: some View {
      TabView {
        GeneralSettingsView()
          .tabItem {
            Label(.settingsGeneralTab, systemImage: "gear")
          }
          .tag(Tabs.general)

        AdvancedSettingsView()
          .tabItem {
            Label(.settingsAdvancedTab, systemImage: "wrench.and.screwdriver.fill")
          }
          .tag(Tabs.advanced)

        DebuggingView(purchaseScreenValue: purchaseScreenValue)
          .tabItem {
            Label(.settingsTestTab, systemImage: "ladybug.fill")
          }
          .tag(Tabs.tests)

        AboutView(
          version: Bundle.applicationVersion,
          subscriptionEndDate: self.marketplace.subscriptionEndDate,
          purchaseScreenValue: self.purchaseScreenValue
        )
        .tabItem {
          Label {
            Text(.settingsAboutTab)
          } icon: {
            Image.resource("Logo-Monochrome").resizable().padding()
          }
        }
        .tag(Tabs.about)
      }
      .padding(20)
      .frame(minWidth: 900, minHeight: 450)
    }

    public init(purchaseScreenValue: PurchaseScreenValue) {
      self.purchaseScreenValue = purchaseScreenValue
    }
  }

  #Preview() {
    PreferencesView<Int>(purchaseScreenValue: 0)
  }

  public extension Settings {
    init<PurchaseScreenValue: Codable & Hashable>(
      purchaseScreenValue: PurchaseScreenValue
    ) where Content == PreferencesView<PurchaseScreenValue> {
      self.init {
        PreferencesView(purchaseScreenValue: purchaseScreenValue)
      }
    }
  }
#endif
