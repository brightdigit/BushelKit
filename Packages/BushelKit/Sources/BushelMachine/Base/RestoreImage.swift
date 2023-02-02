//
// RestoreImage.swift
// Copyright (c) 2023 BrightDigit.
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
  public var location: ImageLocation
  public init(metadata: ImageMetadata, location: ImageLocation) {
    self.metadata = metadata
    self.location = location
  }

  public init?(imageContainer: ImageContainer) {
    guard let location = imageContainer.location else {
      return nil
    }
    self.init(metadata: imageContainer.metadata, location: location)
  }
}
