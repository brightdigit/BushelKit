//
//  ImageMetadata+Previews.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

public import BushelCore
import BushelMacOSCore
import Foundation

extension ImageMetadata {
  public enum Previews {
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
      operatingSystemVersion: OperatingSystemVersion(
        majorVersion: 12,
        minorVersion: 4,
        patchVersion: 0
      ),
      contentLength: 679_276_356_959_953,
      lastModified: Date(timeIntervalSinceReferenceDate: 679_276_356.959953),
      fileExtension: MacOSVirtualization.ipswFileExtension,
      vmSystemID: "macOSApple"
    )
  }
}
