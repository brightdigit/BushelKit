//
// LibraryObject+Extensions.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLibrary
  import BushelLibraryData
  import BushelProgressUI
  import Foundation
  import SwiftData
  import SwiftUI

  extension LibraryObject {
    func save() async throws {
      guard let database else {
        throw LibraryError.missingInitializedProperty(.database)
      }

      let accessibleBookmark = try await entry.accessibleURL(from: database)
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

    func libraryImageObject(withID id: UUID?) async -> LibraryImageObject? {
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
      let entryChild = self.entry.images?.first(where: { $0.imageID == id })
      let entry: LibraryImageEntry?
      if let entryChild {
        entry = entryChild
      } else {
        do {
          entry = try await database?.fetch(
            #Predicate { $0.imageID == id }
          ).first
        } catch {
          Self.logger.error("Error fetching entry \(id) from database: \(error)")
          assertionFailure(error: error)
          return nil
        }
      }
      guard let entry else {
        Self.logger.error("No entry with \(id) from database")
        assertionFailure("No entry with \(id) from database")
        return nil
      }

      return LibraryImageObject(index: index, library: self, entry: entry)
    }

    func bindableImage(withID id: UUID?) async -> Bindable<LibraryImageObject>? {
      await self.libraryImageObject(withID: id).map(Bindable.init(wrappedValue:))
    }
  }
#endif
