//
// MockRestoreImageLoader.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import BushelMachine

struct MockRestoreImageLoader: RestoreImageLoader {
  func load<ImageManagerType>(from _: BushelMachine.FileAccessor, using _: ImageManagerType) async throws -> BushelMachine.RestoreImage where ImageManagerType: BushelMachine.ImageManager {
    try actualResult.get()
  }

  let actualResult: Result<RestoreImage, Error>

  var restoreImageResult: Result<RestoreImage, Error>? {
    actualResult
  }
}
