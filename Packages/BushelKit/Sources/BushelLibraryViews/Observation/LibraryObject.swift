//
// LibraryObject.swift
// Copyright (c) 2023 BrightDigit.
//

#warning("Split this file up")
// swiftlint:disable file_length type_body_length

#if canImport(SwiftUI)
  import BushelCore
  import BushelDataCore
  import BushelLibrary
  import BushelLibraryData
  import BushelLogging
  import BushelProgressUI
  import Foundation
  import Observation
  import SwiftData
  import SwiftUI

  @Observable
  class LibraryObject: LoggerCategorized {
    @ObservationIgnored
    var modelContext: ModelContext?

    @ObservationIgnored
    var librarySystemManager: (any LibrarySystemManaging)?

    var library: Library
    var entry: LibraryEntry

    internal init(library: Library, entry: LibraryEntry) {
      self.library = library
      self.entry = entry
    }

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
          #warning("logging-note: a meaningful mesasge here")
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

      let jsonFileURL = libraryURL.appending(path: Paths.restoreLibraryJSONFileName)
      do {
        let jsonData = try JSON.encoder.encode(library)
        try jsonData.write(to: jsonFileURL)
      } catch {
        throw LibraryError.metadataUpdateError(error, at: jsonFileURL)
      }

      do {
        #warning("logging-note: a meaningful mesasge here")
        try modelContext.save()
      } catch {
        throw LibraryError.fromDatabaseError(error)
      }
    }

    func bindableImage(withID id: UUID?) -> Bindable<LibraryImageObject>? {
      guard let id else {
        #warning("logging-note: a meaningful mesasge here like below guard statements")
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

      return .init(LibraryImageObject(index: index, library: self, entry: entry))
    }

    private func saveChangesTo(_ libraryURL: URL) throws {
      let jsonFileURL = libraryURL.appending(path: Paths.restoreLibraryJSONFileName)
      do {
        let jsonData = try JSON.encoder.encode(library)
        try jsonData.write(to: jsonFileURL)
      } catch {
        throw LibraryError.metadataUpdateError(error, at: jsonFileURL)
      }
    }

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func importRemoteImageAt(
      _ remoteURL: URL,
      metadata: ImageMetadata,
      setProgress: @MainActor @escaping (ProgressOperationView.Properties?) -> Void
    ) async throws {
      guard let modelContext else {
        throw LibraryError.missingInitializedProperty(.modelContext)
      }

      guard let librarySystemManager else {
        throw LibraryError.missingInitializedProperty(.librarySystemManager)
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

      defer {
        libraryURL.stopAccessingSecurityScopedResource()
      }

      let system: any LibrarySystem

      do {
        system = try librarySystemManager.resolve(remoteURL)
      } catch {
        throw try LibraryError.systemResolutionError(error)
      }

      let name = system.label(fromMetadata: metadata).defaultName
      let imageFile = LibraryImageFile(metadata: metadata, name: name)

      let imagesFolderURL = libraryURL.appending(path: Paths.restoreImagesDirectoryName)
      do {
        try FileManager.default.createEmptyDirectory(
          at: imagesFolderURL,
          withIntermediateDirectories: true,
          deleteExistingFile: true
        )
      } catch {
        throw LibraryError.imagesFolderError(error, at: libraryURL)
      }

      let destinationURL = imagesFolderURL.appending(path: imageFile.id.uuidString)
        .appendingPathExtension(remoteURL.pathExtension)
      let progress = try FileManager.default.fileOperationProgress(
        from: remoteURL,
        to: destinationURL,
        totalValue: metadata.contentLength
      )
      await setProgress(
        .init(system: system, metadata: metadata, operation: progress)
      )
      defer {
        Task { @MainActor in
          setProgress(nil)
        }
      }
      do {
        try await progress.execute()
      } catch {
        throw LibraryError.copyFrom(remoteURL, to: libraryURL, withError: error)
      }
      library.items.append(imageFile)
      try saveChangesTo(libraryURL)
      do {
        try entry.appendImage(file: imageFile, using: modelContext)
      } catch {
        throw LibraryError.fromDatabaseError(error)
      }
    }

    func deleteImage(withID id: UUID) throws {
      guard let modelContext else {
        throw LibraryError.missingInitializedProperty(.modelContext)
      }

      guard let librarySystemManager else {
        throw LibraryError.missingInitializedProperty(.librarySystemManager)
      }

      guard let bookmarkData = entry.bookmarkData else {
        throw LibraryError.missingInitializedProperty(.bookmarkData)
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

      defer {
        libraryURL.stopAccessingSecurityScopedResource()
      }

      let imagesURL = libraryURL.appendingPathComponent(Paths.restoreImagesDirectoryName)

      guard let index = self.library.items.firstIndex(where: { $0.id == id }) else {
        assertionFailure()
        return
      }

      let imageFile = library.items.remove(at: index)
      let imageFileURL = imagesURL.appendingPathComponent(imageFile.fileName)
      try FileManager.default.removeItem(at: imageFileURL)
      try modelContext.delete(model: LibraryImageEntry.self, where: #Predicate {
        $0.imageID == id
      })
      try saveChangesTo(libraryURL)
      try modelContext.save()
    }

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func importRestoreImageAt(
      _ importingURL: URL,
      setProgress: @MainActor @escaping (ProgressOperationView.Properties?) -> Void
    ) async throws {
      guard let modelContext else {
        throw LibraryError.missingInitializedProperty(.modelContext)
      }

      guard let librarySystemManager else {
        throw LibraryError.missingInitializedProperty(.librarySystemManager)
      }

      guard importingURL.startAccessingSecurityScopedResource() else {
        throw LibraryError.accessDeniedError(nil, at: importingURL)
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
        importingURL.stopAccessingSecurityScopedResource()
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

      defer {
        libraryURL.stopAccessingSecurityScopedResource()
      }

      let system: any LibrarySystem

      do {
        system = try librarySystemManager.resolve(importingURL)
      } catch {
        throw try LibraryError.systemResolutionError(error)
      }

      let imageFile: LibraryImageFile
      do {
        imageFile = try await system.restoreImageLibraryItemFile(fromURL: importingURL)
      } catch {
        throw LibraryError.imageCorruptedError(error, at: importingURL)
      }

      let imagesFolderURL = libraryURL.appending(path: Paths.restoreImagesDirectoryName)
      do {
        try FileManager.default.createEmptyDirectory(
          at: imagesFolderURL,
          withIntermediateDirectories: true,
          deleteExistingFile: true
        )
      } catch {
        throw LibraryError.imagesFolderError(error, at: libraryURL)
      }

      let destinationURL = imagesFolderURL.appending(path: imageFile.id.uuidString)
        .appendingPathExtension(importingURL.pathExtension)
      let progress = try FileManager.default.fileOperationProgress(
        from: importingURL,
        to: destinationURL,
        totalValue: nil
      )
      await setProgress(
        .init(system: system, metadata: imageFile.metadata, operation: progress)
      )
      defer {
        Task { @MainActor in
          setProgress(nil)
        }
      }
      do {
        try await progress.execute()
      } catch {
        throw LibraryError.copyFrom(importingURL, to: libraryURL, withError: error)
      }
      library.items.append(imageFile)
      try saveChangesTo(libraryURL)
      do {
        try entry.appendImage(file: imageFile, using: modelContext)
      } catch {
        throw LibraryError.fromDatabaseError(error)
      }
    }
  }

  extension LibraryObject {
    // swiftlint:disable:next function_body_length cyclomatic_complexity
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
      if let item = items.first {
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
        do {
          try item.synchronizeWith(library, using: modelContext)
        } catch {
          throw LibraryError.fromDatabaseError(error)
        }
        self.init(library: library, entry: item)
        self.modelContext = modelContext
        self.librarySystemManager = librarySystemManager
        return
      }

      let library: Library
      let newURL: URL
      do {
        newURL = try bookmarkData.fetchURL(using: modelContext, withURL: url)
      } catch {
        throw LibraryError.accessDeniedError(error, at: url)
      }
      guard newURL.startAccessingSecurityScopedResource() else {
        throw LibraryError.accessDeniedError(nil, at: newURL)
      }
      defer {
        newURL.stopAccessingSecurityScopedResource()
      }
      do {
        library = try Library(contentsOf: newURL)
      } catch {
        throw LibraryError.libraryCorruptedError(error, at: newURL)
      }

      let entry: LibraryEntry
      do {
        entry = try LibraryEntry(bookmarkData: bookmarkData, library: library, withContext: modelContext)
        try modelContext.save()
      } catch {
        throw LibraryError.fromDatabaseError(error)
      }
      self.init(library: library, entry: entry)
      self.modelContext = modelContext
      self.librarySystemManager = librarySystemManager
    }

    func matchesURL(_ url: URL) -> Bool {
      guard let bookmarkData = entry.bookmarkData else {
        assertionFailure("Missing bookmark to compare")
        return false
      }

      return url.standardizedFileURL.path == bookmarkData.path
    }

    func startImportRemoteImageAt(
      _ url: URL,
      metadata: ImageMetadata,
      setProgressWith setProgress: @MainActor @escaping (ProgressOperationView.Properties?) -> Void,
      onError: @escaping (Error) -> Void
    ) {
      Task {
        do {
          try await self.importRemoteImageAt(url, metadata: metadata, setProgress: setProgress)
        } catch {
          onError(error)
        }
      }
    }

    func startImportRestoreImageAt(
      _ url: URL,
      setProgressWith setProgress: @MainActor @escaping (ProgressOperationView.Properties?) -> Void,
      onError: @escaping (Error) -> Void
    ) {
      Task {
        do {
          try await self.importRestoreImageAt(url, setProgress: setProgress)
        } catch {
          onError(error)
        }
      }
    }
  }
#endif
