//
// PreviewLibrarySystemManager.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public struct PreviewLibrarySystemManager: LibrarySystemManaging, LibrarySystem {
  public func metadata(fromURL _: URL) async throws -> ImageMetadata {
    .Previews.previewModel
  }

  public func defaultName(fromMetadata _: ImageMetadata) -> String {
    "Preview Image"
  }

  public let allowedContentTypes: Set<FileType> = []
  public let allAllowedFileTypes: [FileType] = []

  public func resolveSystemFor(url _: URL) -> VMSystemID? {
    id
  }

  // public let allAllowedContentTypes: [UTType] = []

  public init(operatingSystemLongName: String, imageName: String) {
    operatingSystemLongNameFor = { _ in operatingSystemLongName }
    imageNameFor = { _ in imageName }
  }

  public init(operatingSystemLongNameFor: @escaping (ImageMetadata) -> String, imageNameFor: @escaping (ImageMetadata) -> String) {
    self.operatingSystemLongNameFor = operatingSystemLongNameFor
    self.imageNameFor = imageNameFor
  }

  let operatingSystemLongNameFor: (ImageMetadata) -> String
  let imageNameFor: (ImageMetadata) -> String

  public func operatingSystemLongName(for metadata: ImageMetadata) -> String {
    operatingSystemLongNameFor(metadata)
  }

  public func imageName(for metadata: ImageMetadata) -> String {
    imageNameFor(metadata)
  }

  public let id: VMSystemID = "preview"

  public func resolve(_: VMSystemID) -> LibrarySystem {
    self
  }
}
