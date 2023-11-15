//
// LibraryObject+Components.swift
// Copyright (c) 2023 BrightDigit.
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
        modelContext: ModelContext,
        system: any LibrarySystemManaging
      ) {
        self.library = library
        self.entry = entry
        self.modelContext = modelContext
        self.system = system
      }

      let library: Library
      let entry: LibraryEntry
      let modelContext: ModelContext
      let system: any LibrarySystemManaging

      private static func entry(
        from item: LibraryEntry?,
        library: Library,
        bookmarkData: BookmarkData,
        using modelContext: ModelContext
      ) throws -> LibraryEntry {
        let entry: LibraryEntry
        if let item {
          do {
            try item.synchronizeWith(library, using: modelContext)
            entry = item
          } catch {
            throw LibraryError.fromDatabaseError(error)
          }
        } else {
          do {
            entry = try LibraryEntry(
              bookmarkData: bookmarkData,
              library: library,
              withContext: modelContext
            )
            try modelContext.save()
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
        withContext modelContext: ModelContext,
        using librarySystemManager: any LibrarySystemManaging
      ) throws {
        let newURL: URL
        do {
          newURL = try bookmarkData.fetchURL(using: modelContext, withURL: url)
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
        let entry = try Self.entry(
          from: item,
          library: library,
          bookmarkData: bookmarkData,
          using: modelContext
        )
        self.init(library: library, entry: entry, modelContext: modelContext, system: librarySystemManager)
      }
    }
  }
#endif
