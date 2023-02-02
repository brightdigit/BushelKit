//
// FileRestoreImageLoader.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public class FileRestoreImageLoader: RestoreImageLoader {
  public func load<ImageManagerType>(
    from file: FileAccessor,
    using manager: ImageManagerType
  ) async throws -> RestoreImage where ImageManagerType: ImageManager {
    let vzMacOSRestoreImage = try await manager.loadFromAccessor(file)

    let imageContainer = try await manager.containerFor(
      image: vzMacOSRestoreImage, fileAccessor: file
    )

    guard let image = RestoreImage(imageContainer: imageContainer) else {
      throw MachineError.undefinedType("missing location", imageContainer)
    }
    return image
  }

  public init() {}
}
