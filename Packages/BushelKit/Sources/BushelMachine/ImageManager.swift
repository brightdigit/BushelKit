//
// ImageManager.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import Foundation

public extension ImageManager {
  func load(from accessor: FileAccessor, using loader: RestoreImageLoader) async throws -> RestoreImage {
    try await loader.load(from: accessor, using: self)
  }
}

public protocol ImageManager: AnyImageManager {
  associatedtype ImageType
  func loadFromAccessor(_ accessor: FileAccessor) async throws -> ImageType
  func imageContainer(vzRestoreImage: ImageType, sha256: SHA256?) async throws -> ImageContainer
}
