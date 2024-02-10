//
// LibraryObject+Components.swift
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
    struct Components {
      internal init(
        library: Library,
        entry: LibraryEntry,
        database: any Database,
        system: any LibrarySystemManaging
      ) {
        self.library = library
        self.entry = entry
        self.database = database
        self.system = system
      }

      let library: Library
      let entry: LibraryEntry
      let database: any Database
      let system: any LibrarySystemManaging

      private static func entry(
        from item: LibraryEntry?,
        library: Library,
        bookmarkData: BookmarkData,
        using database: any Database
      ) async throws -> LibraryEntry {
        let entry: LibraryEntry
        if let item {
          do {
            try await item.synchronizeWith(library, using: database)
            entry = item
          } catch {
            throw LibraryError.fromDatabaseError(error)
          }
        } else {
          do {
            entry = try await LibraryEntry(
              bookmarkData: bookmarkData,
              library: library,
              withDatabase: database
            )
            try await database.save()
          } catch {
            throw LibraryError.fromDatabaseError(error)
          }
        }
        return entry
      }

      internal init(
        item: LibraryEntry?,
        bookmarkData: BookmarkData,
        url: URL,
        withDatabase database: any Database,
        using librarySystemManager: any LibrarySystemManaging
      ) async throws {
        let newURL: URL
        do {
          newURL = try await bookmarkData.fetchURL(using: database, withURL: url)
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
        let entry = try await Self.entry(
          from: item,
          library: library,
          bookmarkData: bookmarkData,
          using: database
        )
        self.init(library: library, entry: entry, database: database, system: librarySystemManager)
      }
    }
  }
#endif
