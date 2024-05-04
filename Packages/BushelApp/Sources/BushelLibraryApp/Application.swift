//
// Application.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLibrary
  import BushelLibraryMacOS
  import BushelLibraryViews
  import SwiftUI
  import UniformTypeIdentifiers

  public protocol Application: App {
    // var appDelegate: AppDelegate { get }
  }

  public extension Application {
    var body: some Scene {
      LibraryScene()
    }
  }
#endif
