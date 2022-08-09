//
// RestoreImage.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/9/22.
//

import Foundation

public struct RestoreImage: Identifiable, Hashable, RestoreImagable {
  public static func == (lhs: RestoreImage, rhs: RestoreImage) -> Bool {
    lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  public let id: UUID = .init()

  public let metadata: ImageMetadata
  public var fileAccessor: FileAccessor?
  public init(metadata: ImageMetadata, fileAccessor: FileAccessor?) {
    self.metadata = metadata
    self.fileAccessor = fileAccessor
  }

  public init(imageContainer: ImageContainer) {
    self.init(metadata: imageContainer.metadata, fileAccessor: imageContainer.fileAccessor)
  }
}

public extension RestoreImage {
  @available(*, deprecated)
  enum DeprecatedLocation {
    case library
    case local
    case remote
    case reloaded
  }

  @available(*, deprecated)
  var location: DeprecatedLocation {
    let url = metadata.url
    if url.isFileURL == true {
      let directoryURL = url.deletingLastPathComponent()
      guard directoryURL.lastPathComponent == "Restore Images" else {
        return .local
      }
      guard directoryURL.deletingLastPathComponent().pathExtension == "bshrilib" else {
        return .local
      }
      return .library
    } else {
      return .remote
    }
  }
}
