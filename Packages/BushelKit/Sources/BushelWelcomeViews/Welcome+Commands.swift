//
// Welcome+Commands.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
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
  }
#endif
