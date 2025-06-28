//
//  OSVer.swift
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
public import OSVer

extension OSVer {
  /// A private dictionary mapping macOS major version numbers to their corresponding release names.
  private static let codeNames: [Int: String] = [
    11: "Big Sur",
    12: "Monterey",
    13: "Ventura",
    14: "Sonoma",
    15: "Sequoia",
    26: "Tahoe",
  ]

  /// The minimum macOS major version number that is supported for virtualization.
  private static let minimumVirtualizationMajor = 12

  /// The release name of the current macOS version, if available.
  public var macOSReleaseName: String? {
    Self.macOSReleaseName(majorVersion: self.majorVersion)
  }

  /// Returns the release name for the specified macOS major version, if available.
  ///
  /// - Parameter majorVersion: The major version number of the macOS release.
  /// - Returns: The release name for the specified major version, or `nil` if it is not available.
  public static func macOSReleaseName(majorVersion: Int) -> String? {
    self.codeNames[majorVersion]
  }

  /// Returns a collection of available macOS major versions,
  /// optionally filtering for only those supported by virtualization.
  ///
  /// - Parameter onlyVirtualizationSupported:
  ///  If `true`, the returned collection will only include major versions
  ///  that are supported for virtualization.
  ///   If `false`, all available major versions will be returned.
  /// - Returns: A collection of available macOS major versions,
  /// either all or only those supported for virtualization.
  public static func availableMajorVersions(onlyVirtualizationSupported: Bool) -> any Collection<
    Int
  > {
    guard onlyVirtualizationSupported else {
      return self.codeNames.keys
    }
    return self.codeNames.keys.filter { $0 >= self.minimumVirtualizationMajor }
  }

  /// Returns a unique identifier for the current macOS version,
  /// composed of the version description and the build version (if available).
  ///
  /// - Parameter buildVersion: The build version of the macOS release, or `nil` if not available.
  /// - Returns: A string representing the unique identifier for the current macOS version.
  public func id(buildVersion: String?) -> String {
    [
      [
        majorVersion,
        minorVersion,
        patchVersion,
      ].map(String.init).joined(separator: "."),
      buildVersion ?? "",
    ]
    .joined(separator: ":")
  }
}
