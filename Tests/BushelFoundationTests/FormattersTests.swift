//
//  FormattersTests.swift
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

import XCTest

@testable import BushelFoundation

internal final class FormattersTests: XCTestCase {
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
    return formatter
  }()

  internal func testLastModifiedDateFormate() {
    let sut = Formatters.lastModifiedDateFormatter

    let now = Date.now

    let expectedFormattedNow = dateFormatter.string(from: now)

    let actualFormattedNow = sut.string(from: now)

    XCTAssertEqual(actualFormattedNow, expectedFormattedNow)
  }

  internal func testFormatDate() {
    let date = Date(timeIntervalSince1970: 1_700_000_000)
    let formatted = date.formatted(Formatters.dateFormat)

    // Should return medium date format
    XCTAssertFalse(formatted.isEmpty)
    XCTAssertTrue(formatted.contains("2023") || formatted.contains("Nov"))
  }

  internal func testFormatDateTime() {
    let date = Date(timeIntervalSince1970: 1_700_000_000)
    let formatted = date.formatted(Formatters.dateTimeFormat)

    // Should include both date and time
    XCTAssertFalse(formatted.isEmpty)
    XCTAssertTrue(formatted.contains("2023") || formatted.contains("Nov"))
    // Time component varies by timezone
  }

  internal func testFormatFileSizeGB() {
    let bytes = 2_500_000_000  // 2.5 GB
    let formatted = bytes.formatted(Formatters.fileSizeFormat)

    XCTAssertEqual(formatted, "2.5 GB")
  }

  internal func testFormatFileSizeMB() {
    let bytes = 500_000_000  // 500 MB
    let formatted = bytes.formatted(Formatters.fileSizeFormat)

    XCTAssertEqual(formatted, "500 MB")
  }

  internal func testFormatFileSizeSmallMB() {
    let bytes = 50_000_000  // 50 MB
    let formatted = bytes.formatted(Formatters.fileSizeFormat)

    XCTAssertEqual(formatted, "50 MB")
  }

  internal func testFormatFileSizeLargeGB() {
    let bytes = 15_000_000_000  // 15 GB
    let formatted = bytes.formatted(Formatters.fileSizeFormat)

    XCTAssertEqual(formatted, "15 GB")
  }

  internal func testFormatFileSizeBoundary() {
    // Exactly 1 GB
    let bytes = 1_000_000_000
    let formatted = bytes.formatted(Formatters.fileSizeFormat)

    XCTAssertEqual(formatted, "1 GB")
  }
}
