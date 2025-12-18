//
//  RestoreImageRecordTests.swift
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

internal final class RestoreImageRecordTests: XCTestCase {
  private func makeSampleRecord() -> RestoreImageRecord {
    RestoreImageRecord(
      version: "14.2.1",
      buildNumber: "23C71",
      releaseDate: Date(timeIntervalSince1970: 1_700_000_000),
      downloadURL:
        URL(
          string:
            "https://updates.cdn-apple.com/2023/macos/23C71/UniversalMac_14.2.1_23C71_Restore.ipsw")!,
      fileSize: 14_500_000_000,
      sha256Hash: "abc123",
      sha1Hash: "def456",
      isSigned: true,
      isPrerelease: false,
      source: "appledb.dev",
      notes: "Security update",
      sourceUpdatedAt: Date(timeIntervalSince1970: 1_700_000_100)
    )
  }

  internal func testInitialization() {
    let record = makeSampleRecord()

    XCTAssertEqual(record.version, "14.2.1")
    XCTAssertEqual(record.buildNumber, "23C71")
    XCTAssertEqual(record.fileSize, 14_500_000_000)
    XCTAssertEqual(record.sha256Hash, "abc123")
    XCTAssertEqual(record.sha1Hash, "def456")
    if let isSigned = record.isSigned {
      XCTAssertTrue(isSigned)
    } else {
      XCTFail("isSigned should not be nil")
    }
    XCTAssertFalse(record.isPrerelease)
    XCTAssertEqual(record.source, "appledb.dev")
    XCTAssertEqual(record.notes, "Security update")
  }

  internal func testRecordName() {
    let record = makeSampleRecord()
    XCTAssertEqual(record.recordName, "RestoreImage-23C71")
  }

  internal func testPrereleaseVersion() {
    let beta = RestoreImageRecord(
      version: "15.0 Beta 3",
      buildNumber: "24A5264n",
      releaseDate: Date(),
      downloadURL: URL(string: "https://example.com/beta.ipsw")!,
      fileSize: 15_000_000_000,
      sha256Hash: "beta123",
      sha1Hash: "beta456",
      isSigned: true,
      isPrerelease: true,
      source: "appledb.dev"
    )

    XCTAssertTrue(beta.isPrerelease)
    XCTAssertTrue(beta.version.contains("Beta"))
  }

  internal func testCodableRoundTrip() throws {
    let original = makeSampleRecord()

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    let encoded = try encoder.encode(original)
    let decoded = try decoder.decode(RestoreImageRecord.self, from: encoded)

    XCTAssertEqual(decoded.version, original.version)
    XCTAssertEqual(decoded.buildNumber, original.buildNumber)
    XCTAssertEqual(decoded.downloadURL, original.downloadURL)
    XCTAssertEqual(decoded.fileSize, original.fileSize)
    XCTAssertEqual(decoded.sha256Hash, original.sha256Hash)
    XCTAssertEqual(decoded.sha1Hash, original.sha1Hash)
    XCTAssertEqual(decoded.isSigned, original.isSigned)
    XCTAssertEqual(decoded.isPrerelease, original.isPrerelease)
    XCTAssertEqual(decoded.source, original.source)
    XCTAssertEqual(decoded.notes, original.notes)
  }

  internal func testOptionalFields() {
    let minimal = RestoreImageRecord(
      version: "14.0",
      buildNumber: "23A344",
      releaseDate: Date(),
      downloadURL: URL(string: "https://example.com/restore.ipsw")!,
      fileSize: 14_000_000_000,
      sha256Hash: "hash256",
      sha1Hash: "hash1",
      isSigned: nil,
      isPrerelease: false,
      source: "ipsw.me",
      notes: nil,
      sourceUpdatedAt: nil
    )

    XCTAssertNil(minimal.isSigned)
    XCTAssertNil(minimal.notes)
    XCTAssertNil(minimal.sourceUpdatedAt)
  }

  internal func testSendable() async {
    let record = makeSampleRecord()
    XCTAssertEqual(record.buildNumber, "23C71")
  }
}
