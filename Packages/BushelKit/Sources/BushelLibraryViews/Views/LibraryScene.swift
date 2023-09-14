//
// LibraryScene.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLibrary
  import BushelLibraryData
  import BushelLogging
  import SwiftData
  import SwiftUI
  import UniformTypeIdentifiers

  public struct LibraryScene: Scene, LoggerCategorized {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) private var dismiss

    public var body: some Scene {
      WindowGroup(for: LibraryFile.self, content: { file in
        LibraryDocumentView(file: file)
      })
    }

    public init() {}
  }
#endif
