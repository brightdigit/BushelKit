//
// Application.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelSettingsViews
  import SwiftUI

  public protocol Application: App {
    // var appDelegate: AppDelegate { get }
  }

  public extension Application {
    var body: some Scene {
      Group {
        Settings()
      }
    }
  }
#endif
