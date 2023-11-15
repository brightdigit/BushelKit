//
// LibraryObject+Convenience.swift
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
    convenience init(components: Components) {
      self.init(library: components.library, entry: components.entry)
      self.modelContext = components.modelContext
      self.librarySystemManager = components.system
    }

    @MainActor
    convenience init(
      _ url: URL,
      withContext modelContext: ModelContext,
      using librarySystemManager: any LibrarySystemManaging
    ) throws {
      let bookmarkData: BookmarkData
      bookmarkData = try BookmarkData.resolveURL(url, with: modelContext)

      defer {
        do {
          try bookmarkData.update(using: modelContext)
        } catch {
          assertionFailure(error: error)
        }
      }

      let bookmarkDataID = bookmarkData.bookmarkID
      var libraryPredicate = FetchDescriptor<LibraryEntry>(
        predicate: #Predicate { $0.bookmarkDataID == bookmarkDataID }
      )

      libraryPredicate.fetchLimit = 1

      let items: [LibraryEntry]
      do {
        items = try modelContext.fetch(libraryPredicate)
      } catch {
        throw LibraryError.fromDatabaseError(error)
      }

      let components = try Components(
        item: items.first,
        bookmarkData: bookmarkData,
        url: url,
        withContext: modelContext,
        using: librarySystemManager
      )
      self.init(components: components)
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
      onError: @escaping (Error) -> Void
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
