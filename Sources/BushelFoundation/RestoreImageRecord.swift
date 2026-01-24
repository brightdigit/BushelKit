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

  /// File size in bytes.
  ///
  /// Uses `Int` (equivalent to `Int64` on all supported 64-bit platforms).
  /// CloudKit stores this as `INT64` via automatic conversion.
  public var fileSize: Int

  /// SHA-256 checksum for integrity verification
  public var sha256Hash: String

  /// SHA-1 hash (from MESU/ipsw.me for compatibility)
  public var sha1Hash: String

  // swiftlint:disable discouraged_optional_boolean
  /// Whether Apple still signs this restore image (nil if unknown)
  public var isSigned: Bool?
  // swiftlint:enable discouraged_optional_boolean

  /// Beta/RC release indicator
  public var isPrerelease: Bool

  /// Data source: "ipsw.me", "mrmacintosh.com", "mesu.apple.com"
  public var source: String

  /// Additional metadata or release notes
  public var notes: String?

  /// When the source last updated this record (nil if unknown)
  public var sourceUpdatedAt: Date?

  /// CloudKit record name based on build number (e.g., "RestoreImage-23C71")
  public var recordName: String {
    "RestoreImage-\(buildNumber)"
  }

  public init(
    version: String,
    buildNumber: String,
    releaseDate: Date,
    downloadURL: URL,
    fileSize: Int,
    sha256Hash: String,
    sha1Hash: String,
    // swiftlint:disable:next discouraged_optional_boolean
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

  /// Validates all fields of the restore image record.
  ///
  /// - Throws: `RestoreImageRecordValidationError` if any field is invalid.
  public func validate() throws {
    try Self.validateSHA256Hash(sha256Hash)
    try Self.validateSHA1Hash(sha1Hash)
    try Self.validateFileSize(fileSize)
    try Self.validateDownloadURL(downloadURL)
  }

  /// Returns true if all fields pass validation.
  public var isValid: Bool {
    do {
      try validate()
      return true
    } catch {
      return false
    }
  }
}

extension RestoreImageRecord {
  fileprivate static func isValidHexadecimal(_ string: String) -> Bool {
    string.allSatisfy { $0.isHexDigit && ($0.isLowercase || $0.isNumber) }
  }

  fileprivate static func validateSHA256Hash(_ hash: String) throws {
    let normalizedHash = hash.lowercased()
    guard normalizedHash.count == 64 else {
      throw RestoreImageRecordValidationError.invalidSHA256Hash(hash, expectedLength: 64)
    }
    guard isValidHexadecimal(normalizedHash) else {
      throw RestoreImageRecordValidationError.nonHexadecimalSHA256(hash)
    }
  }

  fileprivate static func validateSHA1Hash(_ hash: String) throws {
    let normalizedHash = hash.lowercased()
    guard normalizedHash.count == 40 else {
      throw RestoreImageRecordValidationError.invalidSHA1Hash(hash, expectedLength: 40)
    }
    guard isValidHexadecimal(normalizedHash) else {
      throw RestoreImageRecordValidationError.nonHexadecimalSHA1(hash)
    }
  }

  fileprivate static func validateFileSize(_ size: Int) throws {
    guard size > 0 else {
      throw RestoreImageRecordValidationError.nonPositiveFileSize(size)
    }
  }

  fileprivate static func validateDownloadURL(_ url: URL) throws {
    guard let scheme = url.scheme?.lowercased() else {
      throw RestoreImageRecordValidationError.missingURLScheme(url)
    }
    guard scheme == "https" else {
      throw RestoreImageRecordValidationError.insecureDownloadURL(url)
    }
  }
}
