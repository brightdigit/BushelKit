//
// ImageMetadata+Previews.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelMacOSCore
import Foundation

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
      fileExtension: MacOSVirtualization.ipswFileExtension,
      vmSystemID: "macOSApple"
    )

    public static let venturaBeta3 = ImageMetadata(
      isImageSupported: true,
      buildVersion: "22A5295h",
      operatingSystemVersion: OperatingSystemVersion(
        majorVersion: 13, minorVersion: 0, patchVersion: 0
      ),
      contentLength: 679_094_144,
      lastModified: Date(timeIntervalSinceReferenceDate: 679_094_144.0),
      fileExtension: MacOSVirtualization.ipswFileExtension,
      vmSystemID: "macOSApple"
    )

    public static let monterey = ImageMetadata(
      isImageSupported: true,
      buildVersion: "21F79",
      operatingSystemVersion: OperatingSystemVersion(majorVersion: 12, minorVersion: 4, patchVersion: 0),
      contentLength: 679_276_356_959_953,
      lastModified: Date(timeIntervalSinceReferenceDate: 679_276_356.959_953),
      fileExtension: MacOSVirtualization.ipswFileExtension,
      vmSystemID: "macOSApple"
    )
  }
}
