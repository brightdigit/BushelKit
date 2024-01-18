//
// ImageMetadata.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelMacOSCore
import Foundation

extension ImageMetadata {
  // swiftlint:disable:next identifier_name
  static let macOS_13_6_0_22G120: Self = .init(
    isImageSupported: true,
    buildVersion: "22G120",
    operatingSystemVersion: .init(majorVersion: 13, minorVersion: 6, patchVersion: 0),
    contentLength: 12_893_555_341,
    lastModified: .now,
    fileExtension: MacOSVirtualization.ipswFileExtension,
    vmSystemID: .init(stringLiteral: "macOSApple")
  )

  // swiftlint:disable:next identifier_name
  static let macOS_14_0_0_23A344: Self = .init(
    isImageSupported: true,
    buildVersion: "23A344",
    operatingSystemVersion: .init(majorVersion: 14, minorVersion: 0, patchVersion: 0),
    contentLength: 13_893_555_341,
    lastModified: .now,
    fileExtension: MacOSVirtualization.ipswFileExtension,
    vmSystemID: .init(stringLiteral: "macOSApple")
  )

  // swiftlint:disable:next identifier_name
  static let macOS_12_6_0_21G115: Self = .init(
    isImageSupported: true,
    buildVersion: "21G115",
    operatingSystemVersion: .init(majorVersion: 12, minorVersion: 6, patchVersion: 0),
    contentLength: 14_893_555_341,
    lastModified: .now,
    fileExtension: MacOSVirtualization.ipswFileExtension,
    vmSystemID: .init(stringLiteral: "macOSApple")
  )

  // swiftlint:disable:next identifier_name
  static let ubuntu_22_10_0_21F125: Self = .init(
    isImageSupported: true,
    buildVersion: "21F125",
    operatingSystemVersion: .init(majorVersion: 22, minorVersion: 10, patchVersion: 0),
    contentLength: 14_893_555_341,
    lastModified: .now,
    fileExtension: "iso",
    vmSystemID: .init(stringLiteral: "LinuxUbuntu")
  )
}
