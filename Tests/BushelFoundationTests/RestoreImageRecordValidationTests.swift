//
//  RestoreImageRecordValidationTests.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import XCTest

@testable import BushelFoundation

internal final class RestoreImageRecordValidationTests: XCTestCase {
  // swiftlint:disable force_unwrapping
  private static let sampleDownloadURL = URL(
    string: "https://updates.cdn-apple.com/2023/macos/23C71/UniversalMac_14.2.1_23C71_Restore.ipsw"
  )!
  // swiftlint:enable force_unwrapping

  private func makeSampleRecord() -> RestoreImageRecord {
    RestoreImageRecord(
      version: "14.2.1",
      buildNumber: "23C71",
      releaseDate: Date(timeIntervalSince1970: 1_700_000_000),
      downloadURL: Self.sampleDownloadURL,
      fileSize: 14_500_000_000,
      sha256Hash: "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
      sha1Hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709",
      isSigned: true,
      isPrerelease: false,
      source: "appledb.dev",
      notes: "Security update",
      sourceUpdatedAt: Date(timeIntervalSince1970: 1_700_000_100)
    )
  }

  internal func testValidateValidRecord() throws {
    let record = makeSampleRecord()
    try record.validate()
  }

  internal func testValidateInvalidSHA256Length() {
    let record = RestoreImageRecord(
      version: "14.2.1",
      buildNumber: "23C71",
      releaseDate: Date(),
      downloadURL: Self.sampleDownloadURL,
      fileSize: 14_500_000_000,
      sha256Hash: "tooshort",
      sha1Hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709",
      isPrerelease: false,
      source: "test"
    )

    XCTAssertThrowsError(try record.validate()) { error in
      guard
        let validationError = error as? RestoreImageRecordValidationError,
        case .invalidSHA256Hash(let hash, let expectedLength) = validationError
      else {
        XCTFail("Expected invalidSHA256Hash error, got \(error)")
        return
      }
      XCTAssertEqual(hash, "tooshort")
      XCTAssertEqual(expectedLength, 64)
    }
  }

  internal func testValidateInvalidSHA1Length() {
    let record = RestoreImageRecord(
      version: "14.2.1",
      buildNumber: "23C71",
      releaseDate: Date(),
      downloadURL: Self.sampleDownloadURL,
      fileSize: 14_500_000_000,
      sha256Hash: "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
      sha1Hash: "short",
      isPrerelease: false,
      source: "test"
    )

    XCTAssertThrowsError(try record.validate()) { error in
      guard
        let validationError = error as? RestoreImageRecordValidationError,
        case .invalidSHA1Hash(let hash, let expectedLength) = validationError
      else {
        XCTFail("Expected invalidSHA1Hash error, got \(error)")
        return
      }
      XCTAssertEqual(hash, "short")
      XCTAssertEqual(expectedLength, 40)
    }
  }

  internal func testValidateNonHexadecimalSHA256() {
    let invalidSHA256 = "g" + String(repeating: "0", count: 63)
    let record = RestoreImageRecord(
      version: "14.2.1",
      buildNumber: "23C71",
      releaseDate: Date(),
      downloadURL: Self.sampleDownloadURL,
      fileSize: 14_500_000_000,
      sha256Hash: invalidSHA256,
      sha1Hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709",
      isPrerelease: false,
      source: "test"
    )

    XCTAssertThrowsError(try record.validate()) { error in
      guard
        let validationError = error as? RestoreImageRecordValidationError,
        case .nonHexadecimalSHA256(let hash) = validationError
      else {
        XCTFail("Expected nonHexadecimalSHA256 error, got \(error)")
        return
      }
      XCTAssertEqual(hash, invalidSHA256)
    }
  }

  internal func testValidateNonHexadecimalSHA1() {
    let invalidSHA1 = "z" + String(repeating: "0", count: 39)
    let record = RestoreImageRecord(
      version: "14.2.1",
      buildNumber: "23C71",
      releaseDate: Date(),
      downloadURL: Self.sampleDownloadURL,
      fileSize: 14_500_000_000,
      sha256Hash: "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
      sha1Hash: invalidSHA1,
      isPrerelease: false,
      source: "test"
    )

    XCTAssertThrowsError(try record.validate()) { error in
      guard
        let validationError = error as? RestoreImageRecordValidationError,
        case .nonHexadecimalSHA1(let hash) = validationError
      else {
        XCTFail("Expected nonHexadecimalSHA1 error, got \(error)")
        return
      }
      XCTAssertEqual(hash, invalidSHA1)
    }
  }

  internal func testValidateNonPositiveFileSize() {
    let record = RestoreImageRecord(
      version: "14.2.1",
      buildNumber: "23C71",
      releaseDate: Date(),
      downloadURL: Self.sampleDownloadURL,
      fileSize: 0,
      sha256Hash: "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
      sha1Hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709",
      isPrerelease: false,
      source: "test"
    )

    XCTAssertThrowsError(try record.validate()) { error in
      guard
        let validationError = error as? RestoreImageRecordValidationError,
        case .nonPositiveFileSize(let size) = validationError
      else {
        XCTFail("Expected nonPositiveFileSize error, got \(error)")
        return
      }
      XCTAssertEqual(size, 0)
    }
  }

  internal func testValidateInsecureDownloadURL() {
    // swiftlint:disable:next force_unwrapping
    let httpURL = URL(string: "http://example.com/insecure.ipsw")!
    let record = RestoreImageRecord(
      version: "14.2.1",
      buildNumber: "23C71",
      releaseDate: Date(),
      downloadURL: httpURL,
      fileSize: 14_500_000_000,
      sha256Hash: "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
      sha1Hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709",
      isPrerelease: false,
      source: "test"
    )

    XCTAssertThrowsError(try record.validate()) { error in
      guard
        let validationError = error as? RestoreImageRecordValidationError,
        case .insecureDownloadURL(let url) = validationError
      else {
        XCTFail("Expected insecureDownloadURL error, got \(error)")
        return
      }
      XCTAssertEqual(url, httpURL)
    }
  }

  internal func testIsValidProperty() {
    let validRecord = makeSampleRecord()
    XCTAssertTrue(validRecord.isValid)

    let invalidRecord = RestoreImageRecord(
      version: "14.2.1",
      buildNumber: "23C71",
      releaseDate: Date(),
      downloadURL: Self.sampleDownloadURL,
      fileSize: 0,
      sha256Hash: "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
      sha1Hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709",
      isPrerelease: false,
      source: "test"
    )
    XCTAssertFalse(invalidRecord.isValid)
  }
}
