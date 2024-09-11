//
// LibraryImageObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLibrary
  import BushelLibraryData
  import BushelLogging
  import DataThespian
  import Foundation
  import Observation
  import SwiftData
  import SwiftUI

  @MainActor
  @Observable
  internal final class LibraryImageObject: Loggable, Sendable {
    internal private(set) var model: ModelID<LibraryImageEntry>
    internal var library: LibraryObject
    private let index: Int
    private let database: any Database
    internal let imageID: UUID

    internal private(set) var metadata: ImageMetadata

    internal var isDeleted: Bool {
      !library.library.items.indices.contains(index)
    }

    internal var name: String {
      didSet {
        self.library.library.items[index].name = self.name
        Task {
          let name = self.name
          try await self.database.with(self.model) { item in
            item.name = name
          }
        }
      }
    }

    internal init(
      database: any Database,
      index: Int,
      imageID: UUID,
      library: LibraryObject,
      model: ModelID<LibraryImageEntry>
    ) {
      self.database = database
      self.index = index
      self.library = library
      self.imageID = imageID
      self.model = model
      self.name = library.library.items[index].name
      self.metadata = library.library.items[index].metadata
    }

    internal func save() async {
      library.updateMetadata(metadata, at: index)
      Self.logger.debug("Saving \(self.name)")
      do {
        try await self.library.save()
      } catch {
        Self.logger.error("Unable to save \(self.name): \(error)")
      }
    }
  }
#endif
