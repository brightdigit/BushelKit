//
// FormattersTests.swift
// Copyright (c) 2023 BrightDigit.
//

@testable import BushelCore
import XCTest

final class FormattersTests: XCTestCase {
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
    return formatter
  }()

  func testLastModifiedDateFormate() {
    let sut = Formatters.lastModifiedDateFormatter

    let now = Date.now

    let expectedFormattedNow = dateFormatter.string(from: now)

    let actualFormattedNow = sut.string(from: now)

    XCTAssertEqual(actualFormattedNow, expectedFormattedNow)
  }
}
