//
// WelcomeScene.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLogging
  import Foundation
  import SwiftData
  import SwiftUI

  public struct WelcomeScene: Scene {
    public init() {}

    public var body: some Scene {
      WindowGroup { value in
        WelcomeView(value)
      } defaultValue: {
        WelcomeView.Value.default
      }
      .windowStyle(.hiddenTitleBar)
      .windowResizability(.contentSize)
    }
  }
#endif
