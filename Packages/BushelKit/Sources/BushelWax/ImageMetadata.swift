//
// ImageMetadata.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelVirtualization
import Foundation
import SwiftUI

public extension ImageMetadata {
  enum Previews {
    public static let previewModel: ImageMetadata = .init(
      isImageSupported: true,
      buildVersion: "12312SA",
      operatingSystemVersion: .init(
        majorVersion: 12, minorVersion: 0, patchVersion: 0
      ),
      contentLength: 16_000_000_000,
      lastModified: .init(),
      fileExtension: "ipsw",
      vmSystem: "macOS"
    )

    public static let venturaBeta3 = ImageMetadata(
      isImageSupported: true,
      buildVersion: "22A5295h",
      operatingSystemVersion: OperatingSystemVersion(
        majorVersion: 13, minorVersion: 0, patchVersion: 0
      ),
      contentLength: 0,
      lastModified: Date(timeIntervalSinceReferenceDate: 679_094_144.0),
      fileExtension: "ipsw",
      vmSystem: "macOS"
    )

    public static let monterey = ImageMetadata(
      isImageSupported: true,
      buildVersion: "21F79",
      operatingSystemVersion: OperatingSystemVersion(majorVersion: 12, minorVersion: 4, patchVersion: 0),
      contentLength: 0,
      lastModified: Date(timeIntervalSinceReferenceDate: 679_276_356.959_953),
      fileExtension: "ipsw",
      vmSystem: "macOS"
    )
  }
}
