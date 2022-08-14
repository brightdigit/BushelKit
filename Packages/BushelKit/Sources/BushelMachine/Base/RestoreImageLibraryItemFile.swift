//
// RestoreImageLibraryItemFile.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/12/22.
//

import Foundation

public struct RestoreImageLibraryItemFile: Codable, Identifiable, Hashable, ImageContainer {
  public func updatingWithURL(_ url: URL, andFileAccessor newFileAccessor: FileAccessor?) -> RestoreImageLibraryItemFile {
    let fileAccessor: FileAccessor

    if let newFileAccessor = newFileAccessor {
      fileAccessor = newFileAccessor
    } else {
      fileAccessor = self.fileAccessor.updatingWithURL(url)
    }

    return RestoreImageLibraryItemFile(id: id, name: name, metadata: metadata, fileAccessor: fileAccessor)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(name)
    hasher.combine(metadata)
  }

  public static func == (lhs: RestoreImageLibraryItemFile, rhs: RestoreImageLibraryItemFile) -> Bool {
    lhs.id == rhs.id
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Self.CodingKeys)
    let id = try container.decode(UUID.self, forKey: .id)
    let name = try container.decode(String.self, forKey: .name)
    let metadata = try container.decode(ImageMetadata.self, forKey: .metadata)

    self.init(id: id, name: name, metadata: metadata)
  }

  public var fileName: String {
    [id.uuidString, metadata.fileExtension].joined(separator: ".")
  }

  public var name: String
  public let id: UUID
  public let metadata: ImageMetadata
  public var fileAccessor: FileAccessor!

  public var location: ImageLocation {
    .file(fileAccessor)
  }

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case metadata
  }

  private init(id: UUID, name: String? = nil, metadata: ImageMetadata) {
    self.id = id
    self.name = name ?? metadata.defaultName
    self.metadata = metadata
    fileAccessor = nil
  }

  public init(id: UUID, name: String? = nil, metadata: ImageMetadata, fileAccessor: FileAccessor) {
    self.id = id
    self.name = name ?? metadata.defaultName
    self.metadata = metadata
    self.fileAccessor = fileAccessor
  }

  public init?(loadFromImage restoreImage: RestoreImage) {
    guard case let .file(accessor) = restoreImage.location else {
      return nil
    }
    self.init(id: .init(), metadata: restoreImage.metadata, fileAccessor: accessor)
  }
}
