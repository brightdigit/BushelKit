//
// LibrarySystem.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public protocol LibrarySystem {
  var id: VMSystemID { get }
  var allowedContentTypes: Set<FileType> { get }
  func operatingSystemLongName(for metadata: ImageMetadata) -> String
  func imageName(for metadata: ImageMetadata) -> String
  func metadata(fromURL url: URL) async throws -> ImageMetadata
  func defaultName(fromMetadata metadata: ImageMetadata) -> String
}

public extension LibrarySystem {
  func restoreImageLibraryItemFile(fromURL url: URL) async throws -> LibraryImageFile {
    let metadata = try await self.metadata(fromURL: url)
    let name = self.defaultName(fromMetadata: metadata)
    return LibraryImageFile(metadata: metadata, name: name)
  }
}
