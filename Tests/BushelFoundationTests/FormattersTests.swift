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
  // MARK: - RFC 2822 Date Formatter Tests

  internal func testLastModifiedDateFormatterFormat() {
    let sut = Formatters.lastModifiedDateFormatter

    // Test with a known date: 2025-12-19 10:30:45 UTC
    let components = DateComponents(
      calendar: Calendar(identifier: .gregorian),
      timeZone: TimeZone(secondsFromGMT: 0),
      year: 2_025,
      month: 12,
      day: 19,
      hour: 10,
      minute: 30,
      second: 45
    )
    guard let testDate = components.date else {
      XCTFail("Failed to create test date")
      return
    }

    let formatted = sut.string(from: testDate)

    // Expected format: "Fri, 19 Dec 2025 10:30:45 GMT"
    // Verify it matches RFC 2822 format with proper components
    XCTAssertTrue(formatted.contains("Fri"), "Should contain 3-letter day name")
    XCTAssertTrue(formatted.contains("19"), "Should contain day")
    XCTAssertTrue(formatted.contains("Dec"), "Should contain 3-letter month name")
    XCTAssertTrue(formatted.contains("2025"), "Should contain year")
    XCTAssertTrue(formatted.contains("10:30:45"), "Should contain time")
    XCTAssertTrue(formatted.contains("GMT"), "Should contain GMT timezone")

    // Verify exact format
    XCTAssertEqual(formatted, "Fri, 19 Dec 2025 10:30:45 GMT")
  }

  internal func testLastModifiedDateFormatterLocale() {
    let sut = Formatters.lastModifiedDateFormatter

    // Verify locale is POSIX (prevents locale-specific month/day names)
    XCTAssertEqual(sut.locale.identifier, "en_US_POSIX")
  }

  internal func testLastModifiedDateFormatterTimezone() {
    let sut = Formatters.lastModifiedDateFormatter

    // Verify timezone is UTC (0 seconds from GMT)
    XCTAssertEqual(sut.timeZone.secondsFromGMT(), 0)
  }

  internal func testLastModifiedDateFormatterParsing() {
    let sut = Formatters.lastModifiedDateFormatter

    // Test parsing a real HTTP Last-Modified header value
    let headerValue = "Fri, 19 Dec 2025 10:30:45 GMT"
    guard let parsedDate = sut.date(from: headerValue) else {
      XCTFail("Failed to parse RFC 2822 date string")
      return
    }

    // Verify the parsed date
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents(
      in: TimeZone(secondsFromGMT: 0)!,
      from: parsedDate
    )
    XCTAssertEqual(components.year, 2_025)
    XCTAssertEqual(components.month, 12)
    XCTAssertEqual(components.day, 19)
    XCTAssertEqual(components.hour, 10)
    XCTAssertEqual(components.minute, 30)
    XCTAssertEqual(components.second, 45)
  }

  internal func testLastModifiedDateFormatterRoundTrip() {
    let sut = Formatters.lastModifiedDateFormatter

    let originalDate = Date.now
    let formatted = sut.string(from: originalDate)
    guard let parsedDate = sut.date(from: formatted) else {
      XCTFail("Failed to parse formatted date")
      return
    }

    // Due to second precision, dates should be within 1 second of each other
    XCTAssertEqual(
      parsedDate.timeIntervalSince1970,
      originalDate.timeIntervalSince1970,
      accuracy: 1.0
    )
  }

  // MARK: - FormatStyle Tests

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
