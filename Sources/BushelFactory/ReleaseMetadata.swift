//
//  ReleaseMetadata.swift
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

public import BushelFoundation
public import BushelMachine
internal import Foundation

/// A release paired with the installer images available for it.
public struct ReleaseMetadata: Identifiable, Equatable {
  /// The underlying release descriptor.
  public let metadata: any InstallerRelease
  /// The installer images belonging to this release.
  public let images: [any InstallerImage]

  /// The major version of the release, used as its stable identifier.
  public var id: Int {
    metadata.majorVersion
  }

  /// A Boolean value indicating whether this release represents a custom (user-supplied) version.
  public var isCustom: Bool {
    self.metadata.isCustom
  }

  internal init(metadata: any InstallerRelease, images: [any InstallerImage]) {
    self.metadata = metadata
    self.images = images
  }

  /// Compares two release metadata values by their underlying releases.
  /// - Parameters:
  ///   - lhs: The first release metadata to compare.
  ///   - rhs: The second release metadata to compare.
  /// - Returns: `true` if the underlying releases are equal.
  public static func == (lhs: ReleaseMetadata, rhs: ReleaseMetadata) -> Bool {
    lhs.metadata.isEqual(to: rhs.metadata)
  }
}
