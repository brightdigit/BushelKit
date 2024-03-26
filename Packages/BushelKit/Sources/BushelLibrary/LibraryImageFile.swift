//
// LibraryImageFile.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public struct LibraryImageFile: Codable, Identifiable, Hashable {
  enum CodingKeys: String, CodingKey {
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
