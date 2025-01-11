//
//  LibrarySystem.swift
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
public import Foundation
public import RadiantDocs

/// A protocol that defines the requirements for a library system.
public protocol LibrarySystem: Sendable {
  /// The unique identifier for the system.
  var id: VMSystemID { get }

  /// The short name of the system.
  var shortName: String { get }

  /// The set of allowed content types for the system.
  var allowedContentTypes: Set<FileType> { get }

  /// The release collection metadata for the system.
  var releaseCollectionMetadata: any ReleaseCollectionMetadata { get }

  /// Retrieves the metadata for an image from the given URL, using the provided verifier.
  ///
  /// - Parameters:
  ///   - url: The URL of the image.
  ///   - verifier: The verifier to use for the image.
  /// - Returns: The image metadata.
  func metadata(fromURL url: URL, verifier: any SigVerifier) async throws -> ImageMetadata

  /// Generates a metadata label for the given operating system installation.
  ///
  /// - Parameter metadata: The operating system installation metadata.
  /// - Returns: The generated metadata label.
  func label(fromMetadata metadata: any OperatingSystemInstalled) -> MetadataLabel
}

extension LibrarySystem {
  /// Restores an image library item file from the given URL, using the provided verifier.
  ///
  /// - Parameters:
  ///   - url: The URL of the image file.
  ///   - verifier: The verifier to use for the image.
  ///   - id: The unique identifier for the library image file (default is a new UUID).
  /// - Returns: The restored library image file.
  public func restoreImageLibraryItemFile(
    fromURL url: URL,
    verifier: any SigVerifier,
    id: UUID = UUID()
  ) async throws -> LibraryImageFile {
    let metadata = try await self.metadata(fromURL: url, verifier: verifier)
    let name = self.label(fromMetadata: metadata).defaultName
    return LibraryImageFile(id: id, metadata: metadata, name: name)
  }
}
