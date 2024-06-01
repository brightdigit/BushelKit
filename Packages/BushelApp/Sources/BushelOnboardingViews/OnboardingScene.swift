//
// OnboardingScene.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLogging
  import Foundation
  import SwiftData
  import SwiftUI

  public struct OnboardingScene: Scene {
    public var body: some Scene {
      WindowGroup(singleOf: FujiFeaturesView.self)
      #if os(macOS)
        .windowStyle(.hiddenTitleBar)
      #endif
        .windowResizability(.contentSize)
    }

    public init() {}
  }
#endif
