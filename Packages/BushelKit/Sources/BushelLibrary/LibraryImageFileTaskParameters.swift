//
//  LibraryImageFileTaskParameters.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import BushelLogging
import Foundation

private struct LibraryImageFileTaskParameters: Sendable {
  private let system: any LibrarySystem
  fileprivate let id: UUID
  fileprivate let url: URL

  private init(system: any LibrarySystem, id: UUID, url: URL) {
    self.system = system
    self.id = id
    self.url = url
  }

  fileprivate init?(url: URL, manager: any LibrarySystemManaging) {
    guard
      let id = UUID(uuidString: url.deletingPathExtension().lastPathComponent),
      let systemID = manager.resolveSystemFor(url: url) else {
      return nil
    }

    let system = manager.resolve(systemID)
    self.init(system: system, id: id, url: url)
  }

  fileprivate func resolve() async throws -> LibraryImageFile {
    try await system.restoreImageLibraryItemFile(fromURL: url, id: id)
  }
}

extension TaskGroup<LibraryImageFile?> {
  public mutating func addLibraryImageFileTask(
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
