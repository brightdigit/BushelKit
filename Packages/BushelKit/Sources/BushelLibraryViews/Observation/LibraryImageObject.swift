//
// LibraryImageObject.swift
// Copyright (c) 2024 BrightDigit.
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

    var metadata: ImageMetadata

    var isDeleted: Bool {
      !library.library.items.indices.contains(index)
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
      self.metadata = library.library.items[index].metadata
    }

    func save() async {
      library.updateMetadata(metadata, at: index)
      Self.logger.debug("Saving \(self.entry.name)")
      do {
        try await self.library.save()
      } catch {
        Self.logger.error("Unable to save \(self.entry.name): \(error)")
      }
    }
  }
#endif
