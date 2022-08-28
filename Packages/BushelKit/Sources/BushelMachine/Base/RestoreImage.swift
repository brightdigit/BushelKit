//
// RestoreImage.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/21/22.
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

  public init(imageContainer: ImageContainer) {
    self.init(metadata: imageContainer.metadata, location: imageContainer.location)
  }
}
