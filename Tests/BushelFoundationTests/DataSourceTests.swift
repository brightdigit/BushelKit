//
//  DataSourceTests.swift
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

internal final class DataSourceTests: XCTestCase {
  internal func testAllCasesExist() {
    XCTAssertEqual(DataSource.allCases.count, 7)
  }

  internal func testRawValues() {
    XCTAssertEqual(DataSource.appleDB.rawValue, "appledb.dev")
    XCTAssertEqual(DataSource.ipswMe.rawValue, "ipsw.me")
    XCTAssertEqual(DataSource.mesuApple.rawValue, "mesu.apple.com")
    XCTAssertEqual(DataSource.mrMacintosh.rawValue, "mrmacintosh.com")
    XCTAssertEqual(DataSource.theAppleWiki.rawValue, "theapplewiki.com")
    XCTAssertEqual(DataSource.xcodeReleases.rawValue, "xcodereleases.com")
    XCTAssertEqual(DataSource.swiftVersion.rawValue, "swiftversion.net")
  }

  internal func testDefaultIntervals() {
    XCTAssertEqual(DataSource.appleDB.defaultInterval, 6 * 3_600)
    XCTAssertEqual(DataSource.ipswMe.defaultInterval, 12 * 3_600)
    XCTAssertEqual(DataSource.mesuApple.defaultInterval, 1 * 3_600)
    XCTAssertEqual(DataSource.mrMacintosh.defaultInterval, 12 * 3_600)
    XCTAssertEqual(DataSource.theAppleWiki.defaultInterval, 24 * 3_600)
    XCTAssertEqual(DataSource.xcodeReleases.defaultInterval, 12 * 3_600)
    XCTAssertEqual(DataSource.swiftVersion.defaultInterval, 12 * 3_600)
  }

  internal func testEnvironmentKeys() {
    XCTAssertEqual(
      DataSource.appleDB.environmentKey,
      "BUSHEL_FETCH_INTERVAL_APPLEDB_DEV"
    )
    XCTAssertEqual(
      DataSource.ipswMe.environmentKey,
      "BUSHEL_FETCH_INTERVAL_IPSW_ME"
    )
    XCTAssertEqual(
      DataSource.mesuApple.environmentKey,
      "BUSHEL_FETCH_INTERVAL_MESU_APPLE_COM"
    )
  }

  internal func testCodable() throws {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    for source in DataSource.allCases {
      let encoded = try encoder.encode(source)
      let decoded = try decoder.decode(DataSource.self, from: encoded)
      XCTAssertEqual(source, decoded)
    }
  }

  internal func testSendable() {
    // Compile-time check that DataSource is Sendable
    Task {
      let source = DataSource.appleDB
      XCTAssertEqual(source.rawValue, "appledb.dev")
    }
  }
}
