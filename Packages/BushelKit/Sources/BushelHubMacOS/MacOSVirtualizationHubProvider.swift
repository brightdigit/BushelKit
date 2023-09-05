//
// MacOSVirtualizationHubProvider.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelCore
  import BushelHub
  import BushelMacOSCore
  import Foundation
  import Virtualization

  public protocol MacOSVirtualizationHubProvider {}

  private extension MacOSVirtualization {
    static func hubImages() async throws -> [HubImage] {
      let restoreImage = try await VZMacOSRestoreImage.fetchLatestSupported()
      let imageMetadata = try await ImageMetadata(vzRestoreImage: restoreImage, url: restoreImage.url)

      return [
        .init(
          title: self.operatingSystemShortName(for: imageMetadata),
          metadata: imageMetadata,
          url: restoreImage.url
        )
      ]
    }

    static let hubs: [Hub] = [
      Hub(title: "Apple", id: "apple", count: 1, Self.hubImages)
    ]
  }

  public extension MacOSVirtualizationHubProvider {
    var hubs: [Hub] {
      MacOSVirtualization.hubs
    }
  }
#endif
