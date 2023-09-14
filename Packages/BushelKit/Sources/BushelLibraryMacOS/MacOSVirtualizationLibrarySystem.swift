//
// MacOSVirtualizationLibrarySystem.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)

  import BushelCore
  import BushelLibrary
  import BushelMacOSCore
  import Foundation
  import Virtualization

  public struct MacOSVirtualizationLibrarySystem: LibrarySystem {
    public var id: BushelCore.VMSystemID {
      .macOS
    }

    public var allowedContentTypes: Set<BushelCore.FileType> {
      MacOSVirtualization.allowedContentTypes
    }

    public init() {}

    public func operatingSystemLongName(for metadata: ImageMetadata) -> String {
      MacOSVirtualization.operatingSystemLongName(for: metadata)
    }

    public func imageName(for metadata: ImageMetadata) -> String {
      MacOSVirtualization.imageName(for: metadata)
    }

    public func defaultName(fromMetadata metadata: BushelCore.ImageMetadata) -> String {
      MacOSVirtualization.defaultName(fromMetadata: metadata)
    }

    public func metadata(fromURL url: URL) async throws -> ImageMetadata {
      let image = try await VZMacOSRestoreImage.loadFromURL(url)
      return try await ImageMetadata(vzRestoreImage: image, url: url)
    }
  }

#endif
