//
// Application.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelSettingsViews
  import SwiftUI

  public protocol Application: App {
    // var appDelegate: AppDelegate { get }
  }

  public extension Application {
    var body: some Scene {
      Group {
        Settings(purchaseScreenValue: 0)
      }
    }
  }
#endif
