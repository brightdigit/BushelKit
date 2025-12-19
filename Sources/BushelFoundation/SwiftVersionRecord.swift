//
//  SwiftVersionRecord.swift
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

public import Foundation

/// Represents a Swift compiler release bundled with Xcode
public struct SwiftVersionRecord: Codable, Sendable {
  /// Swift version (e.g., "5.9", "5.10", "6.0")
  public var version: String

  /// Release date
  public var releaseDate: Date

  /// Optional swift.org toolchain download
  public var downloadURL: URL?

  /// Beta/snapshot indicator
  public var isPrerelease: Bool

  /// Release notes
  public var notes: String?

  public init(
    version: String,
    releaseDate: Date,
    downloadURL: URL? = nil,
    isPrerelease: Bool,
    notes: String? = nil
  ) {
    self.version = version
    self.releaseDate = releaseDate
    self.downloadURL = downloadURL
    self.isPrerelease = isPrerelease
    self.notes = notes
  }

  /// CloudKit record name based on version (e.g., "SwiftVersion-5.9.2")
  public var recordName: String {
    "SwiftVersion-\(version)"
  }
}
