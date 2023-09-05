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
  class LibraryImageObject: LoggerCategorized {
    internal init(index: Int, library: LibraryObject, entry: LibraryImageEntry) {
      self.index = index
      self.library = library
      self.entry = entry
      self.name = _entry.name
    }

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

    deinit {
      do {
        try self.library.save()
      } catch {
        assertionFailure(error: error)
        Self.logger.error("Unable to save new name: \(error)")
      }
    }
  }
#endif
