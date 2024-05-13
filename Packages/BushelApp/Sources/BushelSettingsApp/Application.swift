//
// Application.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelSettingsViews
  import SwiftUI

  public protocol Application: App {
    // var appDelegate: AppDelegate { get }
  }

  extension Application {
    public var body: some Scene {
      Group {
        Settings(purchaseScreenValue: 0)
      }
    }
  }
#endif
