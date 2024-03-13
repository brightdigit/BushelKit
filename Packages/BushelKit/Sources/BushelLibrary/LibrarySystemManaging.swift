//
// LibrarySystemManaging.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelLogging
import Foundation

public protocol LibrarySystemManaging: Loggable, Sendable {
  var allAllowedFileTypes: [FileType] { get }
  func resolve(_ id: VMSystemID) -> any LibrarySystem
  func resolveSystemFor(url: URL) -> VMSystemID?
}

public extension LibrarySystemManaging where Self: Loggable {
  static var loggingCategory: BushelLogging.Category {
    .library
  }
}

public extension LibrarySystemManaging {
  func resolve(_ url: URL) throws -> any LibrarySystem {
    guard let systemID = resolveSystemFor(url: url) else {
      let error = VMSystemError.unknownSystemBasedOn(url)
      Self.logger.error("Unable able to resolve system for url \(url): \(error.localizedDescription)")
      throw error
    }

    return resolve(systemID)
  }

  @Sendable
  func labelForSystem(_ id: VMSystemID, metadata: any OperatingSystemInstalled) -> MetadataLabel {
    let system = self.resolve(id)
    return system.label(fromMetadata: metadata)
  }

  func libraryImageFiles(ofDirectoryAt imagesURL: URL) async throws -> [LibraryImageFile] {
    let imageFileURLs = try FileManager.default.contentsOfDirectory(
      at: imagesURL,
      includingPropertiesForKeys: []
    )

    let files = await withTaskGroup(of: LibraryImageFile?.self) { group in
      var files = [LibraryImageFile]()
      for imageFileURL in imageFileURLs {
        group.addLibraryImageFileTask(forURL: imageFileURL, librarySystemManager: self, logger: Self.logger)
      }
      for await file in group {
        if let file {
          Self.logger.debug("Completed Metadata for \(file.id)")
          files.append(file)
        }
      }
      return files
    }.sorted(using: LibraryImageFileComparator.default)

    return files
  }
}
