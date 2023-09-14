//
// PurchaseView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(StoreKit) && canImport(SwiftUI)
  import BushelCore
  import BushelViewsCore
  import Foundation
  import StoreKit
  import SwiftUI

  public struct PurchaseView: SingleWindowView {
    @State var windowInitialized = false
    let groupID: String

    public var body: some View {
      SubscriptionStoreView(groupID: groupID)
      #if os(macOS)
        .nsWindowAdaptor(self.setupNSWindow(_:))
      #endif
        .padding(.top, -20)
    }

    public init(groupID: String, windowInitialized: Bool = false) {
      self.windowInitialized = windowInitialized
      self.groupID = groupID
    }

    public init() {
      self.init(groupID: Configuration.Marketplace.groupID)
    }

    #if os(macOS)
      private func setupNSWindow(_ window: NSWindow?) {
        guard let window, !windowInitialized else {
          return
        }
        window.standardWindowButton(.closeButton)?.superview?.isHidden = true
        window.titlebarAppearsTransparent = true
        windowInitialized = true
      }
    #endif
  }
#endif
