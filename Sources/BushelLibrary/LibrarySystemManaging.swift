//
//  LibrarySystemManaging.swift
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

public import BushelCore
public import BushelLogging
public import Foundation
public import RadiantDocs

public protocol LibrarySystemManaging: Loggable, Sendable {
  var allAllowedFileTypes: [FileType] { get }
  func resolve(_ id: VMSystemID) -> any LibrarySystem
  func resolveSystemFor(url: URL) -> VMSystemID?
}

extension LibrarySystemManaging where Self: Loggable {
  public static var loggingCategory: BushelLogging.Category { .library }
}

extension LibrarySystemManaging {
  public func resolve(_ url: URL) throws -> any LibrarySystem {
    guard let systemID = resolveSystemFor(url: url) else {
      let error = VMSystemError.unknownSystemBasedOn(url)
      Self.logger.error(
        "Unable able to resolve system for url \(url): \(error.localizedDescription)"
      )
      throw error
    }

    return resolve(systemID)
  }

  @Sendable public func releaseCollectionMetadata(forSystem id: VMSystemID)
    -> any ReleaseCollectionMetadata
  {
    let system = resolve(id)
    return system.releaseCollectionMetadata
  }

  @Sendable public func labelForSystem(_ id: VMSystemID, metadata: any OperatingSystemInstalled)
    -> MetadataLabel
  {
    let system = resolve(id)
    return system.label(fromMetadata: metadata)
  }

  public func libraryImageFiles(ofDirectoryAt imagesURL: URL) async throws -> [LibraryImageFile] {
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
    }
    .sorted(using: LibraryImageFileComparator.default)

    return files
  }
}
