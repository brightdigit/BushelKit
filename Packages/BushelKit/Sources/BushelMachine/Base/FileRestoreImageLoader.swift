//
// FileRestoreImageLoader.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import Foundation

public class FileRestoreImageLoader: RestoreImageLoader {
  public func load<ImageManagerType>(from file: FileAccessor, using manager: ImageManagerType) async throws -> RestoreImage where ImageManagerType: ImageManager {
    try await Task {
      let sha256: Result<SHA256, Error>
      if let filesha256 = file.sha256 {
        sha256 = .success(filesha256)
      } else {
        async let asha256 = await Task {
          try Result { file.getData() }.unwrap(error: MachineError.undefinedType("missing data from file.", file)).map(CryptoSHA256.hash).map { Data($0) }.map(SHA256.init(digest:)).get()
        }.result
        sha256 = await asha256
      }
      async let vzMacOSRestoreImage = Result { try await manager.loadFromAccessor(file) }

      let virtualImageResultArgs: Result<(ImageManagerType.ImageType, SHA256), Error> = await vzMacOSRestoreImage.tupleWith(sha256)

      let virtualImageResult = await virtualImageResultArgs.flatMap(manager.imageContainer)
      return try virtualImageResult.map(RestoreImage.init(imageContainer:)).get()
    }.value
  }

  public init() {}
}
