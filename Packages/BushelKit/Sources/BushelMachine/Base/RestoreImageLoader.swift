//
// RestoreImageLoader.swift
// Copyright (c) 2022 BrightDigit.
//

public protocol RestoreImageLoader {
  func load<ImageManagerType: ImageManager>(
    from file: FileAccessor,
    using manager: ImageManagerType
  ) async throws -> RestoreImage
}
