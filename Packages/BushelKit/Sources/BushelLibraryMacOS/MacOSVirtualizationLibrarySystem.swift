//
// MacOSVirtualizationLibrarySystem.swift
// Copyright (c) 2024 BrightDigit.
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

    public var shortName: String {
      MacOSVirtualization.shortName
    }

    public var allowedContentTypes: Set<BushelCore.FileType> {
      MacOSVirtualization.allowedContentTypes
    }

    public init() {}

    public func operatingSystemLongName(for metadata: any OperatingSystemInstalled) -> String {
      MacOSVirtualization.operatingSystemLongName(for: metadata)
    }

    public func imageName(for metadata: any OperatingSystemInstalled) -> String {
      MacOSVirtualization.imageName(for: metadata)
    }

    public func defaultName(fromMetadata metadata: any OperatingSystemInstalled) -> String {
      MacOSVirtualization.defaultName(fromMetadata: metadata)
    }

    public func metadata(fromURL url: URL) async throws -> ImageMetadata {
      let image = try await VZMacOSRestoreImage.loadFromURL(url)
      return try await ImageMetadata(vzRestoreImage: image, url: url)
    }

    public func label(fromMetadata metadata: any OperatingSystemInstalled) -> MetadataLabel {
      MacOSVirtualization.label(fromMetadata: metadata)
    }
  }

#endif
