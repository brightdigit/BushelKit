//
// RestoreImageLoader.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

public protocol RestoreImageLoader {
  func load<ImageManagerType: ImageManager>(from file: FileAccessor, using manager: ImageManagerType) async throws -> RestoreImage
}
