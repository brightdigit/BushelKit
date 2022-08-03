//
// RestoreImageLibraryItemFile.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import Foundation

public struct RestoreImageLibraryItemFile: Codable, Identifiable, Hashable, ImageContainer {
  public func updatingWithURL(_ url: URL, andFileAccessor newFileAccessor: FileAccessor?) -> RestoreImageLibraryItemFile {
    let fileAccessor: FileAccessor?

    if let newFileAccessor = newFileAccessor {
      fileAccessor = newFileAccessor
    } else if let oldFileAccessor = self.fileAccessor {
      fileAccessor = oldFileAccessor.updatingWithURL(url, sha256: metadata.sha256)
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

  public func installer() async throws -> ImageInstaller {
    guard let fileAccessor = fileAccessor else {
      throw MachineError.undefinedType("Missing fileAccessor for installer", self)
    }
    guard let manager = AnyImageManagers.imageManager(forSystem: metadata.vmSystem) else {
      throw MachineError.undefinedType("Missing manager for installer", self)
    }
    let image = try await manager.load(from: fileAccessor, using: FileRestoreImageLoader())
    return try await image.installer()
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

  public var id: Data {
    metadata.url.dataRepresentation
  }

  public var name: String
  public let metadata: ImageMetadata
  let location: RestoreImage.Location
  public var fileAccessor: FileAccessor?

  enum CodingKeys: String, CodingKey {
    case name
    case metadata
  }

  public init(name: String? = nil, metadata: ImageMetadata, location: RestoreImage.Location = .library, fileAccessor: FileAccessor? = nil) {
    self.name = name ?? metadata.url.deletingPathExtension().lastPathComponent
    self.metadata = metadata
    self.location = location
    self.fileAccessor = fileAccessor
  }

  public init(restoreImage: RestoreImage) {
    self.init(metadata: restoreImage.metadata, location: restoreImage.location)
  }
}

public extension RestoreImageLibraryItemFile {
  func forMachine() throws -> RestoreImageLibraryItemFile {
    guard let fileAccessor = fileAccessor else {
      throw MachineError.undefinedType("Missing fileAccessor for machine", self)
    }
    let temporaryFileURL = try fileAccessor.getURL()
    return RestoreImageLibraryItemFile(name: name, metadata: metadata.withURL(temporaryFileURL))
  }
}
