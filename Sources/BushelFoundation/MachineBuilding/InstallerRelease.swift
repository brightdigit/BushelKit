//
//  InstallerRelease.swift
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

/// A protocol that represents an installer release.
public protocol InstallerRelease: Sendable, Identifiable, Equatable {
  /// The version name of the release.
  var versionName: String { get }

  /// The release name of the release.
  var releaseName: String { get }

  /// The image name of the release.
  var imageName: String { get }

  /// The major version of the release.
  var majorVersion: Int { get }
}

extension InstallerRelease {
  /// Compares two `InstallerRelease` instances for equality.
  ///
  /// - Parameters:
  ///   - lhs: The first `InstallerRelease` instance to compare.
  ///   - rhs: The second `InstallerRelease` instance to compare.
  /// - Returns: `true` if the two `InstallerRelease` instances are equal, `false` otherwise.
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }

  /// Checks if the current `InstallerRelease` instance is equal to another `InstallerRelease` instance.
  ///
  /// - Parameter other: The `InstallerRelease` instance to compare against.
  /// - Returns: `true` if the two `InstallerRelease` instances are equal, `false` otherwise.
  package func isEqual(to other: some InstallerRelease) -> Bool {
    guard let otherID = other.id as? Self.ID else {
      return false
    }

    return id == otherID
  }
}
