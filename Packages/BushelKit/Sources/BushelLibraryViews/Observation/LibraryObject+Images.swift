//
// LibraryObject+Images.swift
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
    private func saveChangesTo(_ libraryURL: URL) throws {
      let jsonFileURL = libraryURL.appending(path: URL.bushel.paths.restoreLibraryJSONFileName)
      do {
        let jsonData = try JSON.encoder.encode(library)
        try jsonData.write(to: jsonFileURL)
      } catch {
        throw LibraryError.metadataUpdateError(error, at: jsonFileURL)
      }
    }

    private func copyFile(
      _ imageFile: LibraryImageFile,
      at url: URL,
      to libraryURL: URL,
      using system: LibrarySystem,
      modelContext: ModelContext,
      _ setProgress: @MainActor @escaping (ProgressOperationProperties?) -> Void
    ) async throws {
      let imagesFolderURL = libraryURL.appending(path: URL.bushel.paths.restoreImagesDirectoryName)
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
        .appendingPathExtension(url.pathExtension)
      let progress = try FileManager.default.fileOperationProgress(
        from: url,
        to: destinationURL,
        totalValue: imageFile.metadata.contentLength
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
        throw LibraryError.copyFrom(url, to: libraryURL, withError: error)
      }

      library.items.append(imageFile)

      try saveChangesTo(libraryURL)

      do {
        try await entry.appendImage(file: imageFile, using: modelContext)
      } catch {
        throw LibraryError.fromDatabaseError(error)
      }
    }

    @MainActor
    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func importImage(
      _ images: ImportRequest,
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

      guard images.startAccessingSecurityScopedResource() != false else {
        throw LibraryError.accessDeniedError(nil, at: images.url)
      }

      defer {
        do {
          try bookmarkData.update(using: modelContext)
        } catch {
          assertionFailure(error: error)
        }
        images.stopAccessingSecurityScopedResource()
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
        system = try librarySystemManager.resolve(images.url)
      } catch {
        throw try LibraryError.systemResolutionError(error)
      }

      let imageFile = try await LibraryImageFile(request: images, using: system)

      try await copyFile(
        imageFile,
        at: images.url,
        to: libraryURL,
        using: system,
        modelContext: modelContext,
        setProgress
      )
    }

    func deleteImage(withID id: UUID) throws {
      guard let modelContext else {
        throw LibraryError.missingInitializedProperty(.modelContext)
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

      let imagesURL = libraryURL.appendingPathComponent(URL.bushel.paths.restoreImagesDirectoryName)

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
  }
#endif
