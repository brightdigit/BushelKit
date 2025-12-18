//
//  RestoreImageRecord.swift
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

/// Represents a macOS IPSW restore image for Apple Virtualization framework
public struct RestoreImageRecord: Codable, Sendable {
  /// macOS version (e.g., "14.2.1", "15.0 Beta 3")
  public var version: String

  /// Build identifier (e.g., "23C71", "24A5264n")
  public var buildNumber: String

  /// Official release date
  public var releaseDate: Date

  /// Direct IPSW download link
  public var downloadURL: URL

  /// File size in bytes
  public var fileSize: Int

  /// SHA-256 checksum for integrity verification
  public var sha256Hash: String

  /// SHA-1 hash (from MESU/ipsw.me for compatibility)
  public var sha1Hash: String

  /// Whether Apple still signs this restore image (nil if unknown)
  public var isSigned: Bool?

  /// Beta/RC release indicator
  public var isPrerelease: Bool

  /// Data source: "ipsw.me", "mrmacintosh.com", "mesu.apple.com"
  public var source: String

  /// Additional metadata or release notes
  public var notes: String?

  /// When the source last updated this record (nil if unknown)
  public var sourceUpdatedAt: Date?

  public init(
    version: String,
    buildNumber: String,
    releaseDate: Date,
    downloadURL: URL,
    fileSize: Int,
    sha256Hash: String,
    sha1Hash: String,
    isSigned: Bool? = nil,
    isPrerelease: Bool,
    source: String,
    notes: String? = nil,
    sourceUpdatedAt: Date? = nil
  ) {
    self.version = version
    self.buildNumber = buildNumber
    self.releaseDate = releaseDate
    self.downloadURL = downloadURL
    self.fileSize = fileSize
    self.sha256Hash = sha256Hash
    self.sha1Hash = sha1Hash
    self.isSigned = isSigned
    self.isPrerelease = isPrerelease
    self.source = source
    self.notes = notes
    self.sourceUpdatedAt = sourceUpdatedAt
  }

  /// CloudKit record name based on build number (e.g., "RestoreImage-23C71")
  public var recordName: String {
    "RestoreImage-\(buildNumber)"
  }
}
