//
// VirtualizationMacOSRestoreImage.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import Foundation
  import Virtualization

  public struct VirtualizationMacOSRestoreImage {
    public let image: VZMacOSRestoreImage
    public let url: URL

    internal init(image: VZMacOSRestoreImage, url: URL) {
      self.image = image
      self.url = url
    }
  }

  extension VirtualizationMacOSRestoreImage {
    init(url: URL) async throws {
      let image = try await withCheckedThrowingContinuation { continuation in
        VZMacOSRestoreImage.load(
          from: url,
          completionHandler: continuation.resume(with:)
        )
      }
      self.init(image: image, url: url)
    }
  }

#endif
