//
// LibraryObject+Convenience.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelData
  import BushelLibrary
  import BushelProgressUI
  import Foundation
  import SwiftData

  extension LibraryObject {
    convenience init(components: Components) {
      self.init(library: components.library, entry: components.entry)
      self.database = components.database
      self.librarySystemManager = components.system
    }

    convenience init(
      _ url: URL,
      withDatabase database: any Database,
      using librarySystemManager: any LibrarySystemManaging
    ) async throws {
      let bookmarkData: BookmarkData
      bookmarkData = try await BookmarkData.resolveURL(url, with: database)

      let bookmarkDataID = bookmarkData.bookmarkID
      var libraryPredicate = FetchDescriptor<LibraryEntry>(
        predicate: #Predicate { $0.bookmarkDataID == bookmarkDataID }
      )

      libraryPredicate.fetchLimit = 1

      let items: [LibraryEntry]
      do {
        items = try await database.fetch(libraryPredicate)
      } catch {
        throw LibraryError.fromDatabaseError(error)
      }

      let components = try await Components(
        item: items.first,
        bookmarkData: bookmarkData,
        url: url,
        withDatabase: database,
        using: librarySystemManager
      )
      self.init(components: components)

      do {
        try await bookmarkData.update(using: database)
      } catch {
        assertionFailure(error: error)
      }
    }

    func matchesURL(_ url: URL) -> Bool {
      guard let bookmarkData = entry.bookmarkData else {
        assertionFailure("Missing bookmark to compare")
        return false
      }

      return url.standardizedFileURL.path == bookmarkData.path
    }

    func beginImport(
      _ request: ImportRequest,
      setProgressWith setProgress: @MainActor @escaping (ProgressOperationView.Properties?) -> Void,
      onError: @escaping (any Error) -> Void
    ) {
      Task {
        do {
          try await self.importImage(request, setProgress: setProgress)
        } catch {
          onError(error)
        }
      }
    }
  }
#endif
