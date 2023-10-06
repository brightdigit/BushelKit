//
// Welcome+Commands.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelData
  import BushelViewsCore
  import SwiftData
  import SwiftUI

  public enum Welcome {
    public struct WindowCommands: View {
      public init() {}

      @Environment(\.openWindow) private var openWindow
      public var body: some View {
        Button("Welcome to Bushel") {
          openWindow(value: WelcomeView.Value.default)
        }
      }
    }

    public struct OpenCommands: View {
      public init() {}

      @AppStorage("recentDocumentsClearDate") private var recentDocumentsClearDate: Date?
      @Environment(\.openWindow) private var openWindow
      @Environment(\.openFileURL) private var openFileURL
      @Environment(\.allowedOpenFileTypes) private var allowedOpenFileTypes

      public var body: some View {
        Button("Open...") {
          openFileURL(ofFileTypes: allowedOpenFileTypes, using: openWindow)
        }
        RecentDocumentsMenu(recentDocumentsClearDate: recentDocumentsClearDate) {
          recentDocumentsClearDate = .init()
        }
      }
    }
  }
#endif
