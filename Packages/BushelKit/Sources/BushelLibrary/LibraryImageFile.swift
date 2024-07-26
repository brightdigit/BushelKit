//
//  LibraryImageFile.swift
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

public import Foundation

public struct LibraryImageFile: Codable, Identifiable, Hashable, Sendable {
  public enum CodingKeys: String, CodingKey {
    case id
    case name
    case metadata
  }

  public var name: String
  public let id: UUID
  public let metadata: ImageMetadata
  public var fileName: String {
    [id.uuidString, metadata.fileExtension].joined(separator: ".")
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: Self.CodingKeys.self)
    let id = try container.decode(UUID.self, forKey: .id)
    let name = try container.decode(String.self, forKey: .name)
    let metadata = try container.decode(ImageMetadata.self, forKey: .metadata)

    self.init(id: id, metadata: metadata, name: name)
  }

  // swiftlint:disable:next function_default_parameter_at_end
  public init(
    id: UUID = UUID(),
    metadata: ImageMetadata,
    name: String
  ) {
    self.id = id
    self.name = name
    self.metadata = metadata
  }

  public static func == (
    lhs: LibraryImageFile,
    rhs: LibraryImageFile
  ) -> Bool {
    lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(name)
    hasher.combine(metadata)
  }

  public func updatingMetadata(_ metadata: ImageMetadata) -> LibraryImageFile {
    .init(id: self.id, metadata: metadata, name: name)
  }
}
