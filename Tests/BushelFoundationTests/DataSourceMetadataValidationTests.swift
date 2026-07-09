//
//  DataSourceMetadataValidationTests.swift
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

internal final class DataSourceMetadataValidationTests: XCTestCase {
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
