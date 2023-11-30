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
  class LibraryObject: Loggable {
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

    func updateMetadata(_ metadata: ImageMetadata, at index: Int) {
      guard self.library.items.indices.contains(index) else {
        Self.logger.warning("Can't update deleted image \(metadata.vmSystemID.rawValue) \(metadata.operatingSystemVersion) at \(index)")
        return
      }
      let file = self.library.items[index]
      self.library.items[index] = file.updatingMetadata(metadata)
    }
  }
#endif
