//
// WelcomeScene.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelLogging
  import BushelViewsCore
  import Foundation
  import SwiftData
  import SwiftUI

  public struct WelcomeScene: Scene {
    public var body: some Scene {
      WindowGroup(singleOf: WelcomeView.self)
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }

    public init() {}
  }
#endif
