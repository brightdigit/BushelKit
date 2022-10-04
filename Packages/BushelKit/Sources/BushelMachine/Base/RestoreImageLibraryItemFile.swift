//
// RestoreImageLibraryItemFile.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public struct RestoreImageLibraryItemFile: Codable, Identifiable, Hashable, ImageContainer {
  public func updatingWithURL(
    _ url: URL,
    andFileAccessor newFileAccessor: FileAccessor?
  ) -> RestoreImageLibraryItemFile {
    let fileAccessor: FileAccessor

    if let newFileAccessor = newFileAccessor {
      fileAccessor = newFileAccessor
    } else if let oldFileAccessor = self.fileAccessor {
      fileAccessor = oldFileAccessor.updatingWithURL(url)
    } else {
      fileAccessor = URLAccessor(url: url)
    }

    return RestoreImageLibraryItemFile(
      id: id,
      metadata: metadata,
      name: name,
      fileAccessor: fileAccessor
    )
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(name)
    hasher.combine(metadata)
  }

  public static func == (
    lhs: RestoreImageLibraryItemFile,
    rhs: RestoreImageLibraryItemFile
  ) -> Bool {
    lhs.id == rhs.id
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Self.CodingKeys)
    let id = try container.decode(UUID.self, forKey: .id)
    let name = try container.decode(String.self, forKey: .name)
    let metadata = try container.decode(ImageMetadata.self, forKey: .metadata)

    self.init(id: id, metadata: metadata, name: name)
  }

  public var fileName: String {
    [id.uuidString, metadata.fileExtension].joined(separator: ".")
  }

  public var name: String
  public let id: UUID
  public let metadata: ImageMetadata
  public var fileAccessor: FileAccessor?

  public var location: ImageLocation? {
    fileAccessor.map(ImageLocation.file)
  }

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case metadata
  }

  public init(
    id: UUID,
    metadata: ImageMetadata,
    name: String? = nil,
    fileAccessor: FileAccessor? = nil
  ) {
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

public extension RestoreImageLibraryItemFile {
  func getURL() throws -> URL {
    guard let url = try fileAccessor?.getURL() else {
      throw MachineError.undefinedType("no url to return", fileAccessor)
    }
    return url
  }
}