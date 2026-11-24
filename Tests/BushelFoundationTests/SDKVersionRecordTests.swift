//
//  SDKVersionRecordTests.swift
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

internal final class SDKVersionRecordTests: XCTestCase {
  private static let releaseDate = Date(timeIntervalSince1970: 1_780_000_000)
  private static let supersededAt = Date(timeIntervalSince1970: 1_782_000_000)

  private static let superseded = SDKVersionRecord(
    platform: .iOS,
    version: "27.0",
    buildNumber: "24A5318c",
    isPrerelease: true,
    prereleaseLabel: "Beta 5",
    releaseDate: releaseDate,
    xcodeVersion: "XcodeVersion-27A5318c",
    supersededBy: "SDKVersion-iOS-24A340",
    supersededAt: supersededAt
  )

  private static let minimal = SDKVersionRecord(
    platform: .watchOS,
    version: "27.0",
    buildNumber: "24R340",
    isPrerelease: false,
    releaseDate: releaseDate
  )

  internal func testInitialization() {
    let record = Self.superseded

    XCTAssertEqual(record.platform, .iOS)
    XCTAssertEqual(record.version, "27.0")
    XCTAssertEqual(record.buildNumber, "24A5318c")
    XCTAssertTrue(record.isPrerelease)
    XCTAssertEqual(record.prereleaseLabel, "Beta 5")
    XCTAssertEqual(record.releaseDate, Self.releaseDate)
    XCTAssertEqual(record.xcodeVersion, "XcodeVersion-27A5318c")
    XCTAssertEqual(record.supersededBy, "SDKVersion-iOS-24A340")
    XCTAssertEqual(record.supersededAt, Self.supersededAt)
  }

  internal func testRecordName() {
    XCTAssertEqual(Self.superseded.recordName, "SDKVersion-iOS-24A5318c")
    XCTAssertEqual(Self.minimal.recordName, "SDKVersion-watchOS-24R340")
  }

  internal func testOptionalFields() {
    let minimal = Self.minimal

    XCTAssertFalse(minimal.isPrerelease)
    XCTAssertNil(minimal.prereleaseLabel)
    XCTAssertNil(minimal.xcodeVersion)
    XCTAssertNil(minimal.supersededBy)
    XCTAssertNil(minimal.supersededAt)
  }

  internal func testCodableRoundTrip() throws {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    for original in [Self.superseded, Self.minimal] {
      let encoded = try encoder.encode(original)
      let decoded = try decoder.decode(SDKVersionRecord.self, from: encoded)
      XCTAssertEqual(decoded, original)
    }
  }

  internal func testPlatformRawValues() {
    XCTAssertEqual(
      SDKVersionRecord.Platform.allCases.map(\.rawValue),
      ["iOS", "macOS", "tvOS", "visionOS", "watchOS"]
    )
  }

  internal func testUnknownPlatformFailsToDecode() throws {
    let encoded = try JSONEncoder().encode(Self.minimal)
    var object = try XCTUnwrap(
      JSONSerialization.jsonObject(with: encoded) as? [String: Any]
    )
    object["platform"] = "carOS"
    let modified = try JSONSerialization.data(withJSONObject: object)

    XCTAssertThrowsError(try JSONDecoder().decode(SDKVersionRecord.self, from: modified))
  }
}
