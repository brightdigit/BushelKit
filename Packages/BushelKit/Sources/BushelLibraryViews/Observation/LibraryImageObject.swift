//
// LibraryImageObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLibrary
  import BushelLibraryData
  import BushelLogging
  import Foundation
  import Observation
  import SwiftData
  import SwiftUI

  @Observable
  class LibraryImageObject: Loggable {
    var library: LibraryObject
    var entry: LibraryImageEntry
    let index: Int

    var metadata: ImageMetadata {
      library.library.items[index].metadata
    }

    var name: String {
      didSet {
        self.library.library.items[index].name = self.name
        self.entry.name = self.name
      }
    }

    internal init(index: Int, library: LibraryObject, entry: LibraryImageEntry) {
      self.index = index
      self.library = library
      self.entry = entry
      self.name = _entry.name
    }

    @MainActor
    func save() {
      Self.logger.debug("Saving \(self.entry.name)")
      do {
        try self.library.save()
      } catch {
        Self.logger.error("Unable to save \(self.entry.name): \(error)")
      }
    }
  }
#endif
