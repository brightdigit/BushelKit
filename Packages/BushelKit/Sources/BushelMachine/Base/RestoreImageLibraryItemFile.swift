//
// RestoreImageLibraryItemFile.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/9/22.
//

import Foundation

public struct RestoreImageLibraryItemFile: Codable, Identifiable, Hashable, ImageContainer {
  public func updatingWithURL(_ url: URL, andFileAccessor newFileAccessor: FileAccessor?) -> RestoreImageLibraryItemFile {
    let fileAccessor: FileAccessor?

    if let newFileAccessor = newFileAccessor {
      fileAccessor = newFileAccessor
    } else if let oldFileAccessor = self.fileAccessor {
      fileAccessor = oldFileAccessor.updatingWithURL(url)
    } else {
      fileAccessor = nil
    }

    return RestoreImageLibraryItemFile(name: name, metadata: metadata.withURL(url), location: .library, fileAccessor: fileAccessor)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(metadata)
    hasher.combine(location)
  }

  public static func == (lhs: RestoreImageLibraryItemFile, rhs: RestoreImageLibraryItemFile) -> Bool {
    lhs.id == rhs.id
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Self.CodingKeys)
    let name = try container.decode(String.self, forKey: .name)
    let metadata = try container.decode(ImageMetadata.self, forKey: .metadata)

    self.init(name: name, metadata: metadata, location: .library)
  }

  public var fileName: String {
    [id.uuidString, metadata.fileExtension].joined(separator: ".")
  }

  public var name: String
  public let id: UUID
  public let metadata: ImageMetadata
  let location: RestoreImage.DeprecatedLocation
  public var fileAccessor: FileAccessor?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case metadata
  }

  public init(id: UUID = .init(), name: String? = nil, metadata: ImageMetadata, location: RestoreImage.DeprecatedLocation = .library, fileAccessor: FileAccessor? = nil) {
    self.id = id
    self.name = name ?? metadata.url.deletingPathExtension().lastPathComponent
    self.metadata = metadata
    self.location = location
    self.fileAccessor = fileAccessor
  }

  public init(restoreImage: RestoreImage) {
    self.init(metadata: restoreImage.metadata, location: restoreImage.location, fileAccessor: restoreImage.fileAccessor)
  }
}

public extension RestoreImageLibraryItemFile {
  func forMachine() throws -> RestoreImageLibraryItemFile {
    guard let fileAccessor = fileAccessor else {
      throw MachineError.undefinedType("Missing fileAccessor for machine", self)
    }
    let temporaryFileURL = try fileAccessor.getURL()
    return RestoreImageLibraryItemFile(name: name, metadata: metadata.withURL(temporaryFileURL), fileAccessor: fileAccessor)
  }
}
