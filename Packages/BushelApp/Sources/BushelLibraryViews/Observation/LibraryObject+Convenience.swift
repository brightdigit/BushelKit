//
// LibraryObject+Convenience.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelData
  import BushelLibrary
  import BushelProgressUI
  import DataThespian
  import Foundation
  import SwiftData

  extension LibraryObject {
    internal convenience init(components: Components) {
      self.init(
        library: components.library,
        model: components.model,
        database: components.database,
        librarySystemManager: components.system
      )
    }

    internal convenience init(
      url: URL,
      withDatabase database: any Database,
      using librarySystemManager: any LibrarySystemManaging
    ) async throws {
      let newURL: URL
      let bookmarkID: UUID
      do {
        (newURL, bookmarkID) = try await BookmarkData.withDatabase(database, fromURL: url) { bookmarkData in
          try (bookmarkData.fetchURL(), bookmarkData.bookmarkID)
        }
      } catch {
        throw try LibraryError.bookmarkError(error)
      }
      guard newURL.startAccessingSecurityScopedResource() else {
        throw LibraryError.accessDeniedError(nil, at: newURL)
      }
      defer {
        newURL.stopAccessingSecurityScopedResource()
      }
      let library: Library
      do {
        library = try Library(contentsOf: newURL)
      } catch {
        throw LibraryError.libraryCorruptedError(error, at: newURL)
      }
      let model: ModelID<LibraryEntry> = if let existingModel = try await database.first(#Predicate<LibraryEntry> { $0.bookmarkDataID == bookmarkID }) {
        existingModel
      } else {
        await database.insert {
          LibraryEntry(bookmarkDataID: bookmarkID)
        }
      }

      try await LibraryEntry.syncronizeModel(model, with: library, using: database)
      let components = Components(library: library, model: model, database: database, system: librarySystemManager)
      self.init(components: components)

      do {
        try await database.first(
          #Predicate<BookmarkData> {
            $0.bookmarkID == bookmarkID
          }
        ) { bookmark in
          guard let bookmark else {
            assertionFailure("Missing Bookmark: \(url)")
            Self.logger.error("Missing Bookmark: \(url)")
            return
          }

          bookmark.update()
        }
      } catch {
        assertionFailure(error: error)
      }
    }

    public var bookmarkID: UUID {
      get async throws {
        guard let database else {
          throw LibraryError.missingInitializedProperty(.database)
        }

        let bookmarkDataID = try await database.with(self.model) { libraryEntry in
          libraryEntry.bookmarkDataID
        }
        return bookmarkDataID
      }
    }

    public var url: URL {
      get async throws {
        let bookmarkID = try await self.bookmarkID

        guard let database else {
          throw LibraryError.missingInitializedProperty(.database)
        }
        let url = try await database.first(
          #Predicate<BookmarkData> { $0.bookmarkID == bookmarkID }
        ) {
          try $0?.fetchURL()
        }

        guard let url else {
          throw LibraryError.missingBookmark()
        }

        return url
      }
    }

    internal func matchesURL(_ url: URL) async throws -> Bool {
      try await url.standardizedFileURL.path == self.url.standardizedFileURL.path
    }

    internal func beginImport(
      _ request: ImportRequest,
      setProgressWith setProgress:
      @MainActor @Sendable @escaping (ProgressOperationView.Properties?) -> Void,
      onError: @MainActor @escaping @Sendable (any Error) -> Void
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
