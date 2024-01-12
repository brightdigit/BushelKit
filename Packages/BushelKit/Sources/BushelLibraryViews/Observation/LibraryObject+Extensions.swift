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
    @MainActor
    // swiftlint:disable:next cyclomatic_complexity
    func save() throws {
      guard let modelContext else {
        throw LibraryError.missingInitializedProperty(.modelContext)
      }

      guard let bookmarkData = entry.bookmarkData else {
        throw LibraryError.missingInitializedProperty(.bookmarkData)
      }

      defer {
        do {
          try bookmarkData.update(using: modelContext)
        } catch {
          assertionFailure(error: error)
        }
      }

      let libraryURL: URL
      do {
        libraryURL = try bookmarkData.fetchURL(using: modelContext, withURL: nil)
      } catch {
        throw try LibraryError.bookmarkError(error)
      }

      let canAccessFile = libraryURL.startAccessingSecurityScopedResource()

      guard canAccessFile else {
        throw LibraryError.accessDeniedError(nil, at: libraryURL)
      }

      let jsonFileURL = libraryURL.appending(path: URL.bushel.paths.restoreLibraryJSONFileName)
      do {
        let jsonData = try JSON.encoder.encode(library)
        try jsonData.write(to: jsonFileURL)
      } catch {
        throw LibraryError.metadataUpdateError(error, at: jsonFileURL)
      }

      do {
        try modelContext.save()
      } catch {
        throw LibraryError.fromDatabaseError(error)
      }
    }

    func libraryImageObject(withID id: UUID?) -> LibraryImageObject? {
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
      do {
        entry = try entryChild ?? modelContext?.fetch(
          FetchDescriptor<LibraryImageEntry>(
            predicate: #Predicate { $0.imageID == id }
          )
        ).first
      } catch {
        Self.logger.error("Error fetching entry \(id) from database: \(error)")
        assertionFailure(error: error)
        return nil
      }
      guard let entry else {
        Self.logger.error("No entry with \(id) from database")
        assertionFailure("No entry with \(id) from database")
        return nil
      }

      return LibraryImageObject(index: index, library: self, entry: entry)
    }

    func bindableImage(withID id: UUID?) -> Bindable<LibraryImageObject>? {
      self.libraryImageObject(withID: id).map(Bindable.init(wrappedValue:))
    }
  }
#endif
