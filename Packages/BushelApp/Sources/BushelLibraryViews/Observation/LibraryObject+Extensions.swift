//
// LibraryObject+Extensions.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelDataCore
  import BushelLibrary
  import BushelLibraryData
  import BushelProgressUI
  import DataThespian
  import Foundation
  import SwiftData
  import SwiftUI

  extension LibraryObject {
    func accessibleURL() async throws -> BookmarkURL {
      guard let database else {
        throw LibraryError.missingInitializedProperty(.database)
      }
      let bookmarkID = try await self.bookmarkID
      return try await BookmarkURL(bookmarkID: bookmarkID, database: database, failureType: LibraryEntry.BookmarkedErrorType.self)
    }

    internal func save() async throws {
      guard let database else {
        throw LibraryError.missingInitializedProperty(.database)
      }

      let accessibleBookmark = try await self.accessibleURL()
      let libraryURL = accessibleBookmark.url

      let jsonFileURL = libraryURL.appending(path: URL.bushel.paths.restoreLibraryJSONFileName)
      do {
        let jsonData = try JSON.encoder.encode(library)
        try jsonData.write(to: jsonFileURL)
      } catch {
        throw LibraryError.metadataUpdateError(error, at: jsonFileURL)
      }

      try await accessibleBookmark.stopAccessing(updateTo: database)
    }

    internal func libraryImageObject(withID id: UUID?) async -> LibraryImageObject? {
      Self.logger.debug("Creating Bindable Image for \(id?.uuidString ?? "nil")")
      guard let id else {
        Self.logger.debug("No id for image")
        return nil
      }
      guard let index = library.items.firstIndex(where: { $0.id == id }) else {
        Self.logger.error("Unable to find child image with id: \(id)")
        assertionFailure("Unable to find child image with id: \(id)")
        return nil
      }

      let imageModel: ModelID<LibraryImageEntry>?

      do {
        imageModel = try await database?.first(
          #Predicate {
            $0.imageID == id
          }
        )
      } catch {
        Self.logger.error("Error fetching entry \(id) from database: \(error)")
        assertionFailure(error: error)
        return nil
      }
      guard let imageModel, let database else {
        Self.logger.error("No entry with \(id) from database")
        assertionFailure("No entry with \(id) from database")
        return nil
      }

      return LibraryImageObject(database: database, index: index, imageID: id, library: self, model: imageModel)
    }

    internal func bindableImage(withID id: UUID?) async -> Bindable<LibraryImageObject>? {
      await self.libraryImageObject(withID: id).map(Bindable.init(wrappedValue:))
    }
  }
#endif
