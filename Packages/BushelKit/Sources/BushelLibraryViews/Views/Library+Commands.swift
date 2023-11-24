//
// Library+Commands.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelLibrary
  import BushelLogging
  import BushelViewsCore
  import Foundation
  import SwiftUI
  import UniformTypeIdentifiers

  public extension Library {
    struct NewCommands: View, Loggable {
      public init() {}

      @Environment(\.newLibrary) private var newLibrary
      @Environment(\.openWindow) private var openWindow

      public var body: some View {
        Button("Library...") {
          NewFilePanel<LibraryFileSpecifications>()(with: openWindow)
        }
      }
    }

    @available(*, deprecated, message: "Use single open panel...")
    struct OpenCommands: View, Loggable {
      public init() {}

      @Environment(\.openWindow) private var openWindow
      public var body: some View {
        Button("Library...") {
          OpenFilePanel<LibraryFileSpecifications>()(with: openWindow)
        }
      }
    }
  }
#endif
