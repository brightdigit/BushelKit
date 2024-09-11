//
// PurchaseView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(StoreKit) && canImport(SwiftUI)
  import BushelCore
  import BushelLocalization

  public import BushelLogging

  public import BushelMarket

  public import BushelMarketEnvironment

  import BushelViewsCore
  import Foundation

  public import RadiantKit
  import StoreKit

  public import SwiftUI

  @MainActor
  public struct PurchaseView: SingleWindowView, Loggable {
    public typealias Value = PurchaseWindowValue

    @State var windowInitialized = false
    @State var marketingContentHeight: CGFloat?
    @State var screenHeight: CGFloat?
    let groupID: String

    var minHeight: CGFloat? {
      marketingContentHeight.map { $0 + 400 }
    }

    var marketingContentSizeClassProperties: PurchaseHeaderViewProperties? {
      Self.logger.debug("Calcuating marketingContentSizeClassProperties based on \(screenHeight ?? -1)")
      switch screenHeight {
      case .none:
        return nil

      case .some(950...):
        return .extraLarge

      case .some:
        return .small
      }
    }

    public var body: some View {
      SubscriptionStoreView(groupID: groupID) {
        Group {
          if let marketingContentSizeClassProperties {
            PurchaseHeaderView(properties: marketingContentSizeClassProperties) {
              PurchaseFeatureItem.automaticSnapshots
              PurchaseFeatureItem.snapshotNotes
              PurchaseFeatureItem.shutdownSnapshot
            }.onGeometry(self.setMarketingContentHeight(basedOnProxy:))
          }
        }
      }

      .frame(idealWidth: 615, maxWidth: 700, minHeight: minHeight, alignment: .center)
      .subscriptionStorePolicyDestination(url: .bushel.privacyPolicy, for: .privacyPolicy)
      .subscriptionStorePolicyDestination(url: .bushel.termsOfUse, for: .termsOfService)
      .storeButton(.visible, for: .restorePurchases, .policies)
      .subscriptionStoreButtonLabel(.multiline)

      #if os(macOS)
        .nsWindowAdaptor(self.setupNSWindow(_:))
      #endif
        .padding(.top, -20)
        .backgroundStyle(.clear)
    }

    public init(groupID: String, windowInitialized: Bool = false) {
      self.windowInitialized = windowInitialized
      self.groupID = groupID
    }

    public init() {
      self.init(groupID: MarketplaceSettings.default.primaryGroupID)
    }

    private func setMarketingContentHeight(basedOnProxy geometry: GeometryProxy) {
      Self.logger.debug("setMarketingContentHeight based on \(geometry.size.height)")

      self.marketingContentHeight = marketingContentHeight ?? geometry.size.height
    }

    #if os(macOS)
      @MainActor
      private func setupNSWindow(_ window: NSWindow?) {
        guard let window, !windowInitialized else {
          return
        }
        window.standardWindowButton(.closeButton)?.superview?.isHidden = true
        window.titlebarAppearsTransparent = true
        self.screenHeight = NSScreen.main?.frame.height
        windowInitialized = true
      }
    #endif
  }
#endif
