//
//  ImageMetadata.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

internal import BushelFoundation
internal import BushelMacOSCore
internal import Foundation

// swift-format-ignore: AlwaysUseLowerCamelCase
extension ImageMetadata {
  // swiftlint:disable:next identifier_name
  internal static let macOS_13_6_0_22G120: Self = .init(
    isImageSupported: true,
    buildVersion: "22G120",
    operatingSystemVersion: .init(majorVersion: 13, minorVersion: 6, patchVersion: 0),
    contentLength: 12_893_555_341,
    lastModified: .now,
    fileExtension: MacOSVirtualization.ipswFileExtension,
    sigVerification: .unsigned,
    vmSystemID: .init(stringLiteral: "macOSApple")
  )

  // swiftlint:disable:next identifier_name
  internal static let macOS_14_0_0_23A344: Self = .init(
    isImageSupported: true,
    buildVersion: "23A344",
    operatingSystemVersion: .init(majorVersion: 14, minorVersion: 0, patchVersion: 0),
    contentLength: 13_893_555_341,
    lastModified: .now,
    fileExtension: MacOSVirtualization.ipswFileExtension,
    sigVerification: .unsigned,
    vmSystemID: .init(stringLiteral: "macOSApple")
  )

  // swiftlint:disable:next identifier_name
  internal static let macOS_12_6_0_21G115: Self = .init(
    isImageSupported: true,
    buildVersion: "21G115",
    operatingSystemVersion: .init(majorVersion: 12, minorVersion: 6, patchVersion: 0),
    contentLength: 14_893_555_341,
    lastModified: .now,
    fileExtension: MacOSVirtualization.ipswFileExtension,
    sigVerification: .unsigned,
    vmSystemID: .init(stringLiteral: "macOSApple")
  )

  // swiftlint:disable:next identifier_name
  internal static let ubuntu_22_10_0_21F125: Self = .init(
    isImageSupported: true,
    buildVersion: "21F125",
    operatingSystemVersion: .init(majorVersion: 22, minorVersion: 10, patchVersion: 0),
    contentLength: 14_893_555_341,
    lastModified: .now,
    fileExtension: "iso",
    sigVerification: .unsigned,
    vmSystemID: .init(stringLiteral: "LinuxUbuntu")
  )
}
