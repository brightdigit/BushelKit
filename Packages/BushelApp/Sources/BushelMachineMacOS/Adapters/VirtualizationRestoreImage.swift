//
// VirtualizationRestoreImage.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import Foundation

  public import Virtualization

  public struct VirtualizationRestoreImage: Sendable {
    public let image: VZMacOSRestoreImage
    public let url: URL
  }

  extension VirtualizationRestoreImage {
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
