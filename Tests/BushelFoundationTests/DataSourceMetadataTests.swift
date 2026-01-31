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

  // MARK: - Validation Tests

  internal func testStaticValidationSuccess() throws {
    try DataSourceMetadata.validate(
      sourceName: "appledb.dev",
      recordTypeName: "RestoreImage",
      recordCount: 42,
      fetchDurationSeconds: 1.5
    )
  }

  internal func testStaticValidationEmptySourceName() {
    XCTAssertThrowsError(
      try DataSourceMetadata.validate(
        sourceName: "",
        recordTypeName: "RestoreImage",
        recordCount: 0,
        fetchDurationSeconds: 0
      )
    ) { error in
      guard
        let validationError = error as? DataSourceMetadataValidationError,
        case .emptySourceName = validationError.details
      else {
        XCTFail("Expected emptySourceName error, got \(error)")
        return
      }
    }
  }

  internal func testStaticValidationEmptyRecordTypeName() {
    XCTAssertThrowsError(
      try DataSourceMetadata.validate(
        sourceName: "appledb.dev",
        recordTypeName: "",
        recordCount: 0,
        fetchDurationSeconds: 0
      )
    ) { error in
      guard
        let validationError = error as? DataSourceMetadataValidationError,
        case .emptyRecordTypeName = validationError.details
      else {
        XCTFail("Expected emptyRecordTypeName error, got \(error)")
        return
      }
    }
  }

  internal func testStaticValidationNonASCIISourceName() {
    XCTAssertThrowsError(
      try DataSourceMetadata.validate(
        sourceName: "apple🍎db",
        recordTypeName: "RestoreImage",
        recordCount: 0,
        fetchDurationSeconds: 0
      )
    ) { error in
      guard
        let validationError = error as? DataSourceMetadataValidationError,
        case .nonASCIISourceName = validationError.details
      else {
        XCTFail("Expected nonASCIISourceName error, got \(error)")
        return
      }
    }
  }

  internal func testStaticValidationNonASCIIRecordTypeName() {
    XCTAssertThrowsError(
      try DataSourceMetadata.validate(
        sourceName: "appledb.dev",
        recordTypeName: "RestoreImage™",
        recordCount: 0,
        fetchDurationSeconds: 0
      )
    ) { error in
      guard
        let validationError = error as? DataSourceMetadataValidationError,
        case .nonASCIIRecordTypeName = validationError.details
      else {
        XCTFail("Expected nonASCIIRecordTypeName error, got \(error)")
        return
      }
    }
  }

  internal func testStaticValidationRecordNameTooLong() {
    // Create a sourceName that will result in a record name > 255 characters
    // "metadata-" (9 chars) + sourceName + "-" (1 char) + recordTypeName
    // So we need sourceName + recordTypeName > 245 characters
    let longSourceName = String(repeating: "a", count: 200)
    let longRecordTypeName = String(repeating: "b", count: 50)

    XCTAssertThrowsError(
      try DataSourceMetadata.validate(
        sourceName: longSourceName,
        recordTypeName: longRecordTypeName,
        recordCount: 0,
        fetchDurationSeconds: 0
      )
    ) { error in
      guard
        let validationError = error as? DataSourceMetadataValidationError,
        case .recordNameTooLong = validationError.details
      else {
        XCTFail("Expected recordNameTooLong error, got \(error)")
        return
      }
    }
  }

  internal func testStaticValidationNegativeRecordCount() {
    XCTAssertThrowsError(
      try DataSourceMetadata.validate(
        sourceName: "appledb.dev",
        recordTypeName: "RestoreImage",
        recordCount: -1,
        fetchDurationSeconds: 0
      )
    ) { error in
      guard
        let validationError = error as? DataSourceMetadataValidationError,
        case .negativeRecordCount = validationError.details
      else {
        XCTFail("Expected negativeRecordCount error, got \(error)")
        return
      }
    }
  }

  internal func testStaticValidationNegativeFetchDuration() {
    XCTAssertThrowsError(
      try DataSourceMetadata.validate(
        sourceName: "appledb.dev",
        recordTypeName: "RestoreImage",
        recordCount: 0,
        fetchDurationSeconds: -0.5
      )
    ) { error in
      guard
        let validationError = error as? DataSourceMetadataValidationError,
        case .negativeFetchDuration = validationError.details
      else {
        XCTFail("Expected negativeFetchDuration error, got \(error)")
        return
      }
    }
  }
}
