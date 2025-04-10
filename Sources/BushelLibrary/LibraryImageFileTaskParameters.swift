//
//  LibraryImageFileTaskParameters.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

public import BushelFoundation
internal import BushelLogging
public import Foundation

#if canImport(os)
  public import os
#elseif canImport(Logging)
  public import Logging
#endif

/// Represents the parameters needed to perform a task related to a library image file.
private struct LibraryImageFileTaskParameters: Sendable {
  /// The library system associated with the image file.
  private let system: any LibrarySystem
  /// The signature verifier for the library system.
  private let verifier: any SigVerifier
  /// The unique identifier for the image file.
  fileprivate let id: UUID
  /// The URL of the image file.
  fileprivate let url: URL

  /// Initializes a `LibraryImageFileTaskParameters` instance.
  ///
  /// - Parameters:
  ///   - system: The library system associated with the image file.
  ///   - verifier: The signature verifier for the library system.
  ///   - id: The unique identifier for the image file.
  ///   - url: The URL of the image file.
  private init(system: any LibrarySystem, verifier: any SigVerifier, id: UUID, url: URL) {
    self.system = system
    self.verifier = verifier
    self.id = id
    self.url = url
  }

  /// Initializes a `LibraryImageFileTaskParameters` instance from a URL.
  ///
  /// - Parameters:
  ///   - url: The URL of the image file.
  ///   - manager: The library system manager.
  ///   - verifyManager: The signature verification manager.
  ///
  /// - Returns: An optional `LibraryImageFileTaskParameters` instance,
  /// or `nil` if the parameters cannot be initialized.
  fileprivate init?(
    url: URL, manager: any LibrarySystemManaging, verifyManager: any SigVerificationManaging
  ) {
    guard
      let id = UUID(uuidString: url.deletingPathExtension().lastPathComponent),
      let systemID = manager.resolveSystemFor(url: url)
    else {
      return nil
    }

    let system = manager.resolve(systemID)
    let verifier = verifyManager.resolve(systemID)
    self.init(system: system, verifier: verifier, id: id, url: url)
  }

  /// Resolves the library image file.
  ///
  /// - Throws: Any errors that occur during the resolution process.
  ///
  /// - Returns: The resolved library image file.
  fileprivate func resolve() async throws -> LibraryImageFile {
    try await self.system.restoreImageLibraryItemFile(
      fromURL: self.url,
      verifier: self.verifier,
      id: self.id
    )
  }
}

extension TaskGroup<LibraryImageFile?> {
  /// Adds a library image file task to the task group.
  ///
  /// - Parameters:
  ///   - imageFileURL: The URL of the image file.
  ///   - librarySystemManager: The library system manager.
  ///   - verifyManager: The signature verification manager.
  ///   - logger: The logger to use for logging.
  public mutating func addLibraryImageFileTask(
    forURL imageFileURL: URL,
    librarySystemManager: any LibrarySystemManaging,
    verifyManager: any SigVerificationManaging,
    logger: Logger
  ) {
    guard
      let parameters = LibraryImageFileTaskParameters(
        url: imageFileURL,
        manager: librarySystemManager,
        verifyManager: verifyManager
      )
    else {
      logger.warning("Invalid Image File: \(imageFileURL.lastPathComponent)")
      do {
        try FileManager.default.removeItem(at: imageFileURL)
      } catch {
        logger.error(
          "Unable to Delete \(imageFileURL.lastPathComponent): \(error.localizedDescription)"
        )
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
