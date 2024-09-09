//
// WishListView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLogging
  import BushelMarketEnvironment
  import BushelViewsCore
  import BushelWishListEnvironment

  import SwiftUI
  @preconcurrency import WishKit

  internal struct WishListView: View, SingleWindowView, Loggable {
    typealias Value = WishListValue
    @Environment(\.marketplace) private var marketplace

    let isConfigured: Bool

    internal var body: some View {
      WishKit.view.onAppear {
        if let payment = marketplace.payment {
          WishKit.updateUser(payment: payment)
        }
      }
    }

    internal init() {
      self.init(configureFrom: .main)
    }

    internal init(configureFrom bundle: Bundle) {
      let configuration = bundle.wishKitConfiguration
      self.init(configuration: configuration)
    }

    internal init(configuration: WishKitConfiguration?) {
      assert(configuration != nil)
      if let configuration {
        self.init(configuration: configuration)
      } else {
        self.init(isConfigured: false)
      }
    }

    private init(isConfigured: Bool) {
      assert(isConfigured)
      self.isConfigured = isConfigured
    }

    internal init(configuration: WishKitConfiguration) {
      WishKit.configure(with: configuration.apiKey)
      WishKit.theme.primaryColor = .Apple.s500
      isConfigured = true
    }
  }

#endif
