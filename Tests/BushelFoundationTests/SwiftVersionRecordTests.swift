//
//  SwiftVersionRecordTests.swift
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

internal final class SwiftVersionRecordTests: XCTestCase {
  private func makeSampleRecord() -> SwiftVersionRecord {
    SwiftVersionRecord(
      version: "5.9.2",
      releaseDate: Date(timeIntervalSince1970: 1_700_000_000),
      downloadURL: "https://swift.org/download",
      isPrerelease: false,
      notes: "Bug fixes and improvements"
    )
  }

  internal func testInitialization() {
    let record = makeSampleRecord()

    XCTAssertEqual(record.version, "5.9.2")
    XCTAssertEqual(record.downloadURL, "https://swift.org/download")
    XCTAssertFalse(record.isPrerelease)
    XCTAssertEqual(record.notes, "Bug fixes and improvements")
  }

  internal func testRecordName() {
    let record = makeSampleRecord()
    XCTAssertEqual(record.recordName, "SwiftVersion-5.9.2")
  }

  internal func testSnapshotVersion() {
    let snapshot = SwiftVersionRecord(
      version: "6.0-dev",
      releaseDate: Date(),
      isPrerelease: true
    )

    XCTAssertTrue(snapshot.isPrerelease)
  }

  internal func testCodableRoundTrip() throws {
    let original = makeSampleRecord()

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    let encoded = try encoder.encode(original)
    let decoded = try decoder.decode(SwiftVersionRecord.self, from: encoded)

    XCTAssertEqual(decoded.version, original.version)
    XCTAssertEqual(decoded.downloadURL, original.downloadURL)
    XCTAssertEqual(decoded.isPrerelease, original.isPrerelease)
    XCTAssertEqual(decoded.notes, original.notes)
  }

  internal func testOptionalFields() {
    let minimal = SwiftVersionRecord(
      version: "5.8",
      releaseDate: Date(),
      isPrerelease: false
    )

    XCTAssertNil(minimal.downloadURL)
    XCTAssertNil(minimal.notes)
  }
}
