//
//  DataSourceMetadataTests.swift
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

internal final class DataSourceMetadataTests: XCTestCase {
  internal func testInitialization() {
    let now = Date()
    let metadata = DataSourceMetadata(
      sourceName: "appledb.dev",
      recordTypeName: "RestoreImage",
      lastFetchedAt: now,
      sourceUpdatedAt: now,
      recordCount: 42,
      fetchDurationSeconds: 1.5,
      lastError: nil
    )

    XCTAssertEqual(metadata.sourceName, "appledb.dev")
    XCTAssertEqual(metadata.recordTypeName, "RestoreImage")
    XCTAssertEqual(metadata.lastFetchedAt, now)
    XCTAssertEqual(metadata.sourceUpdatedAt, now)
    XCTAssertEqual(metadata.recordCount, 42)
    XCTAssertEqual(metadata.fetchDurationSeconds, 1.5)
    XCTAssertNil(metadata.lastError)
  }

  internal func testRecordName() {
    let metadata = DataSourceMetadata(
      sourceName: "appledb.dev",
      recordTypeName: "RestoreImage",
      lastFetchedAt: Date()
    )

    XCTAssertEqual(metadata.recordName, "metadata-appledb.dev-RestoreImage")
  }

  internal func testCodableRoundTrip() throws {
    let now = Date()
    let original = DataSourceMetadata(
      sourceName: "ipsw.me",
      recordTypeName: "XcodeVersion",
      lastFetchedAt: now,
      sourceUpdatedAt: now,
      recordCount: 10,
      fetchDurationSeconds: 0.8,
      lastError: "Network timeout"
    )

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    let encoded = try encoder.encode(original)
    let decoded = try decoder.decode(DataSourceMetadata.self, from: encoded)

    XCTAssertEqual(decoded.sourceName, original.sourceName)
    XCTAssertEqual(decoded.recordTypeName, original.recordTypeName)
    XCTAssertEqual(
      decoded.lastFetchedAt.timeIntervalSince1970,
      original.lastFetchedAt.timeIntervalSince1970,
      accuracy: 0.001
    )
    XCTAssertEqual(decoded.recordCount, original.recordCount)
    XCTAssertEqual(decoded.fetchDurationSeconds, original.fetchDurationSeconds)
    XCTAssertEqual(decoded.lastError, original.lastError)
  }

  internal func testSendable() {
    Task {
      let metadata = DataSourceMetadata(
        sourceName: "test",
        recordTypeName: "Test",
        lastFetchedAt: Date()
      )
      XCTAssertEqual(metadata.sourceName, "test")
    }
  }
}
