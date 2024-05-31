//
// WishScene.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelViewsCore
  import Foundation
  import SwiftUI

  public struct WishScene: Scene {
    public var body: some Scene {
      WindowGroup(singleOf: WishListView.self)
        .windowResizability(.contentMinSize)
      #if os(macOS)
        .windowStyle(.hiddenTitleBar)
      #endif
    }

    public init() {}
  }
#endif
