//
//  LibrarySystemManaging.swift
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
public import BushelLogging
public import Foundation
public import RadiantDocs

/// A protocol that defines the requirements for managing a library system.
public protocol LibrarySystemManaging: Loggable, Sendable {
  /// The list of all allowed file types for the library system.
  var allAllowedFileTypes: [FileType] { get }

  /// Resolves a library system based on the provided `VMSystemID`.
  ///
  /// - Parameter id: The `VMSystemID` of the library system to resolve.
  /// - Returns: The resolved `LibrarySystem`.
  func resolve(_ id: VMSystemID) -> any LibrarySystem

  /// Resolves the `VMSystemID` for the given URL.
  ///
  /// - Parameter url: The URL to resolve the `VMSystemID` for.
  /// - Returns: The resolved `VMSystemID`, if any.
  func resolveSystemFor(url: URL) -> VMSystemID?
}

extension LibrarySystemManaging where Self: Loggable {
  /// The logging category for the `LibrarySystemManaging` protocol.
  public static var loggingCategory: BushelLogging.Category {
    .library
  }
}

extension LibrarySystemManaging {
  /// Resolves a library system based on the provided URL.
  ///
  /// - Parameter url: The URL to resolve the library system for.
  /// - Throws: A `VMSystemError` if the system cannot be resolved for the given URL.
  /// - Returns: The resolved `LibrarySystem`.
  public func resolve(_ url: URL) throws -> any LibrarySystem {
    guard let systemID = resolveSystemFor(url: url) else {
      let error = VMSystemError.unknownSystemBasedOn(url)
      Self.logger.error(
        "Unable able to resolve system for url \(url): \(error.localizedDescription)"
      )
      throw error
    }

    return self.resolve(systemID)
  }

  /// Retrieves the release collection metadata for the specified library system.
  ///
  /// - Parameter id: The `VMSystemID` of the library system to retrieve the metadata for.
  /// - Returns: The `ReleaseCollectionMetadata` for the specified library system.
  @Sendable
  public func releaseCollectionMetadata(forSystem id: VMSystemID) -> any ReleaseCollectionMetadata {
    let system = self.resolve(id)
    return system.releaseCollectionMetadata
  }

  /// Generates a metadata label for the specified library system and metadata.
  ///
  /// - Parameters:
  ///   - id: The `VMSystemID` of the library system.
  ///   - metadata: The `OperatingSystemInstalled` metadata to use for the label.
  /// - Returns: The `MetadataLabel` for the specified library system and metadata.
  @Sendable
  public func labelForSystem(_ id: VMSystemID, metadata: any OperatingSystemInstalled)
    -> MetadataLabel
  {
    let system = self.resolve(id)
    return system.label(fromMetadata: metadata)
  }

  /// Retrieves the library image files located in the specified directory,
  /// verifying them using the provided verification manager.
  ///
  /// - Parameters:
  ///   - imagesURL: The URL of the directory containing the library image files.
  ///   - verifyManager: The `SigVerificationManaging` instance to use for verifying the image files.
  /// - Throws: Throws an error if there is an issue retrieving or verifying the image files.
  /// - Returns: An array of `LibraryImageFile` instances.
  public func libraryImageFiles(
    ofDirectoryAt imagesURL: URL, verifyUsing verifyManager: any SigVerificationManaging
  ) async throws -> [LibraryImageFile] {
    let imageFileURLs = try FileManager.default.contentsOfDirectory(
      at: imagesURL,
      includingPropertiesForKeys: []
    )

    let files = await withTaskGroup(of: LibraryImageFile?.self) { group in
      var files = [LibraryImageFile]()
      for imageFileURL in imageFileURLs {
        group.addLibraryImageFileTask(
          forURL: imageFileURL,
          librarySystemManager: self,
          verifyManager: verifyManager,
          logger: Self.logger
        )
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
