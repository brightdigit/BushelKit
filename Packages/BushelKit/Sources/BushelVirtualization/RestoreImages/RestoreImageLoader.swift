//
// RestoreImageLoader.swift
// Copyright (c) 2023 BrightDigit.
//

@available(*, deprecated, message: "What's the purpose of this?")
public protocol RestoreImageLoader {
  func load<ImageManagerType: ImageManager>(
    from file: FileAccessor,
    using manager: ImageManagerType
  ) async throws -> RestoreImage
}
