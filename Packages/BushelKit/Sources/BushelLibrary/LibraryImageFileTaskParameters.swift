//
// LibraryImageFileTaskParameters.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelLogging
import Foundation

struct LibraryImageFileTaskParameters {
  let system: any LibrarySystem
  let id: UUID
  let url: URL

  private init(system: any LibrarySystem, id: UUID, url: URL) {
    self.system = system
    self.id = id
    self.url = url
  }

  init?(url: URL, manager: any LibrarySystemManaging) {
    guard
      let id = UUID(uuidString: url.deletingPathExtension().lastPathComponent),
      let systemID = manager.resolveSystemFor(url: url) else {
      return nil
    }

    let system = manager.resolve(systemID)
    self.init(system: system, id: id, url: url)
  }

  func resolve() async throws -> LibraryImageFile {
    try await system.restoreImageLibraryItemFile(fromURL: url, id: id)
  }
}

public extension TaskGroup<LibraryImageFile?> {
  mutating func addLibraryImageFileTask(
    forURL imageFileURL: URL,
    librarySystemManager: any LibrarySystemManaging,
    logger: Logger
  ) {
    guard let parameters = LibraryImageFileTaskParameters(
      url: imageFileURL,
      manager: librarySystemManager
    ) else {
      logger.warning("Invalid Image File: \(imageFileURL.lastPathComponent)")
      do {
        try FileManager.default.removeItem(at: imageFileURL)
      } catch {
        logger.error("Unable to Delete \(imageFileURL.lastPathComponent): \(error.localizedDescription)")
      }
      return
    }

    logger.debug("Updating Metadata for \(parameters.id)")
    self.addTask {
      do {
        return try await parameters.resolve()
      } catch {
        logger.debug("Error Metadata for \(parameters.id): \(error.localizedDescription)")
        do {
          try FileManager.default.removeItem(at: imageFileURL)
        } catch {
          logger.error(
            "Unable to Delete \(parameters.url.lastPathComponent): \(error.localizedDescription)"
          )
        }
        return nil
      }
    }
  }
}
