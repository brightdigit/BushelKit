//
// LibraryObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLibrary
  import BushelLibraryData
  import BushelLogging
  import BushelProgressUI
  import SwiftData
  import SwiftUI

  @Observable
  class LibraryObject: LoggerCategorized {
    @ObservationIgnored
    var modelContext: ModelContext?

    @ObservationIgnored
    var librarySystemManager: (any LibrarySystemManaging)?

    var library: Library
    var entry: LibraryEntry

    internal init(library: Library, entry: LibraryEntry) {
      self.library = library
      self.entry = entry
    }
  }
#endif
