//
// Machine+Commands.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import BushelViewsCore
  import Foundation

  public import SwiftUI
  import UniformTypeIdentifiers

  public enum Machine {
    public struct NewCommands: View {
      public init() {}

      @Environment(\.openWindow) private var openWindow
      public var body: some View {
        Button(.menuMachine) {
          openWindow(value: MachineBuildRequest())
        }
      }
    }
  }
#endif
