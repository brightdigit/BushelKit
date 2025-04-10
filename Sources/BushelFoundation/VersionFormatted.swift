//
//  VersionFormatted.swift
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

internal import Foundation

public struct VersionFormatted: Sendable {
  /// The marketing version of the app.
  public let marketingVersion: String

  /// The build number of the app in hexadecimal format.
  public let buildNumberHex: String

  /// Initializes a `VersionFormatted` struct
  /// with the given marketing version and build number in hexadecimal format.
  ///
  /// - Parameters:
  ///   - marketingVersion: The marketing version of the app.
  ///   - buildNumberHex: The build number of the app in hexadecimal format.
  public init(marketingVersion: String, buildNumberHex: String) {
    self.marketingVersion = marketingVersion
    self.buildNumberHex = buildNumberHex
  }
}

extension VersionFormatted {
  /// Initializes a `VersionFormatted` struct from a `Version` object.
  ///
  /// - Parameter version: The `Version` object to be converted.
  public init(version: Version) {
    self.init(
      marketingVersion: version.description,
      buildNumberHex: version.buildNumberHex()
    )
  }
}
