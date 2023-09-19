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

    public let shortName = "macOS"

    public var allowedContentTypes: Set<BushelCore.FileType> {
      MacOSVirtualization.allowedContentTypes
    }

    public init() {}

    public func operatingSystemLongName(for metadata: OperatingSystemInstalled) -> String {
      MacOSVirtualization.operatingSystemLongName(for: metadata)
    }

    public func imageName(for metadata: OperatingSystemInstalled) -> String {
      MacOSVirtualization.imageName(for: metadata)
    }

    public func defaultName(fromMetadata metadata: OperatingSystemInstalled) -> String {
      MacOSVirtualization.defaultName(fromMetadata: metadata)
    }

    public func metadata(fromURL url: URL) async throws -> ImageMetadata {
      let image = try await VZMacOSRestoreImage.loadFromURL(url)
      return try await ImageMetadata(vzRestoreImage: image, url: url)
    }

    public func label(fromMetadata metadata: OperatingSystemInstalled) -> MetadataLabel {
      .init(
        operatingSystemLongName: self.operatingSystemLongName(for: metadata),
        defaultName: self.defaultName(fromMetadata: metadata),
        imageName: self.imageName(for: metadata),
        systemName: self.shortName,
        versionName: MacOSVirtualization.codeNameFor(
          operatingSystemVersion: metadata.operatingSystemVersion
        )
      )
    }
  }

#endif
