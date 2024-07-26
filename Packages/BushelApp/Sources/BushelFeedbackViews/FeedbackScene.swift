//
// FeedbackScene.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelViewsCore
  import Foundation

  public import SwiftUI

  public struct FeedbackScene: Scene {
    public var body: some Scene {
      WindowGroup(singleOf: FeedbackView.self)
        .windowResizability(.contentSize)
      #if os(macOS)
        .windowStyle(.hiddenTitleBar)
      #endif
    }

    public init() {}
  }
#endif
