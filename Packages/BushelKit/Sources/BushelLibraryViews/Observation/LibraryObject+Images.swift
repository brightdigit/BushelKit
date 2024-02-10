//
// LibraryObject+Images.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelData
  import BushelLibrary
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
      using system: any LibrarySystem,
      database: any Database,
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
        try await entry.appendImage(file: imageFile, using: database)
      } catch {
        throw LibraryError.fromDatabaseError(error)
      }
    }

    func importImage(
      _ images: ImportRequest,
      setProgress: @MainActor @escaping (ProgressOperationView.Properties?) -> Void
    ) async throws {
      guard let database else {
        throw LibraryError.missingInitializedProperty(.database)
      }

      guard let librarySystemManager else {
        throw LibraryError.missingInitializedProperty(.librarySystemManager)
      }

      guard images.startAccessingSecurityScopedResource() != false else {
        throw LibraryError.accessDeniedError(nil, at: images.url)
      }

      let accessibleBookmark = try await entry.accessibleURL(from: database)
      let libraryURL = accessibleBookmark.url
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
        database: database,
        setProgress
      )

      try await accessibleBookmark.stopAccessing(updateTo: database)
    }

    func deleteImage(withID id: UUID) async throws {
      guard let database else {
        throw LibraryError.missingInitializedProperty(.database)
      }

      let accessibleBookmark = try await entry.accessibleURL(from: database)
      let libraryURL = accessibleBookmark.url
      let imagesURL = libraryURL.appendingPathComponent(URL.bushel.paths.restoreImagesDirectoryName)

      guard let index = self.library.items.firstIndex(where: { $0.id == id }) else {
        assertionFailure()
        return
      }

      let imageFile = library.items.remove(at: index)
      let imageFileURL = imagesURL.appendingPathComponent(imageFile.fileName)
      try FileManager.default.removeItem(at: imageFileURL)
      try await database.delete(model: LibraryImageEntry.self, where: #Predicate {
        $0.imageID == id
      })
      try saveChangesTo(libraryURL)
      try await accessibleBookmark.stopAccessing(updateTo: database)
    }
  }
#endif
