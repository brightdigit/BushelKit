//
// FileRestoreImageLoader.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public class FileRestoreImageLoader: RestoreImageLoader {
  public func load<ImageManagerType>(
    from file: FileAccessor,
    using manager: ImageManagerType
  ) async throws -> RestoreImage where ImageManagerType: ImageManager {
    let vzMacOSRestoreImage = try await manager.loadFromAccessor(file)

    let imageContainer = try await manager.containerFor(image: vzMacOSRestoreImage, fileAccessor: file)

    return RestoreImage(imageContainer: imageContainer)
  }

  public init() {}
}
