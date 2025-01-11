//
//  LibraryImageFile.swift
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

/// A struct representing an image file in a library.
public struct LibraryImageFile: Codable, Identifiable, Hashable, Sendable {
  /// The coding keys used for encoding and decoding the `LibraryImageFile` struct.
  public enum CodingKeys: String, CodingKey {
    case id
    case name
    case metadata
  }

  /// The name of the image file.
  public var name: String
  /// The unique identifier of the image file.
  public let id: UUID
  /// The metadata associated with the image file.
  public let metadata: ImageMetadata
  /// The file name of the image file, composed of the ID and file extension.
  public var fileName: String {
    [self.id.uuidString, self.metadata.fileExtension].joined(separator: ".")
  }

  /// Initializes a `LibraryImageFile` struct from a decoder.
  ///
  /// - Parameter decoder: The decoder used to decode the `LibraryImageFile` struct.
  /// - Throws: An error that may occur during the decoding process.
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: Self.CodingKeys.self)
    let id = try container.decode(UUID.self, forKey: .id)
    let name = try container.decode(String.self, forKey: .name)
    let metadata = try container.decode(ImageMetadata.self, forKey: .metadata)

    self.init(id: id, metadata: metadata, name: name)
  }

  /// Initializes a `LibraryImageFile` struct with the provided parameters.
  ///
  /// - Parameters:
  ///   - id: The unique identifier of the image file. Default is a new `UUID`.
  ///   - metadata: The metadata associated with the image file.
  ///   - name: The name of the image file.
  public init(
    id: UUID = UUID(),
    metadata: ImageMetadata,
    name: String
  ) {
    self.id = id
    self.name = name
    self.metadata = metadata
  }

  /// Compares two `LibraryImageFile` instances for equality.
  ///
  /// - Parameters:
  ///   - lhs: The left-hand side `LibraryImageFile` instance.
  ///   - rhs: The right-hand side `LibraryImageFile` instance.
  /// - Returns: `true` if the two instances have the same ID, `false` otherwise.
  public static func == (
    lhs: LibraryImageFile,
    rhs: LibraryImageFile
  ) -> Bool {
    lhs.id == rhs.id
  }

  /// Hashes the `LibraryImageFile` instance.
  ///
  /// - Parameter hasher: The hasher to use for hashing the instance.
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
    hasher.combine(self.name)
    hasher.combine(self.metadata)
  }

  /// Creates a new `LibraryImageFile` instance with updated metadata.
  ///
  /// - Parameter metadata: The new metadata to be used for the updated instance.
  /// - Returns: A new `LibraryImageFile` instance with the updated metadata.
  public func updatingMetadata(_ metadata: ImageMetadata) -> LibraryImageFile {
    .init(id: self.id, metadata: metadata, name: self.name)
  }
}
