//
// LibraryObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelData
  import BushelLibrary
  import BushelLibraryData
  import BushelLogging
  import BushelProgressUI
  import SwiftData
  import SwiftUI

  @Observable
  final class LibraryObject: Loggable, Sendable {
    var library: Library
    var entry: LibraryEntry

    @ObservationIgnored
    internal private(set) var database: (any Database)?

    @ObservationIgnored
    internal private(set) var librarySystemManager: (any LibrarySystemManaging)?

    internal init(
      library: Library,
      entry: LibraryEntry,
      database: (any Database)? = nil,
      librarySystemManager: (any LibrarySystemManaging)? = nil
    ) {
      self.database = database
      self.librarySystemManager = librarySystemManager
      self.library = library
      self.entry = entry
    }

    func updateMetadata(_ metadata: ImageMetadata, at index: Int) {
      guard self.library.items.indices.contains(index) else {
        // swiftlint:disable:next line_length
        Self.logger.warning("Can't update deleted image \(metadata.vmSystemID.rawValue) \(metadata.operatingSystemVersion) at \(index)")
        return
      }
      let file = self.library.items[index]
      self.library.items[index] = file.updatingMetadata(metadata)
    }
  }
#endif
