//
//  XcodeVersionRecordTests.swift
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

internal final class XcodeVersionRecordTests: XCTestCase {
  private func makeSampleRecord() -> XcodeVersionRecord {
    XcodeVersionRecord(
      version: "15.1",
      buildNumber: "15C65",
      releaseDate: Date(timeIntervalSince1970: 1_700_000_000),
      downloadURL: "https://developer.apple.com/xcode/download",
      fileSize: 8_000_000_000,
      isPrerelease: false,
      minimumMacOS: "RestoreImage-23A344",
      includedSwiftVersion: "SwiftVersion-5.9.2",
      sdkVersions: #"{"macOS": "14.2", "iOS": "17.2", "watchOS": "10.2"}"#,
      notes: "Stable release"
    )
  }

  internal func testInitialization() {
    let record = makeSampleRecord()

    XCTAssertEqual(record.version, "15.1")
    XCTAssertEqual(record.buildNumber, "15C65")
    XCTAssertEqual(record.downloadURL, "https://developer.apple.com/xcode/download")
    XCTAssertEqual(record.fileSize, 8_000_000_000)
    XCTAssertFalse(record.isPrerelease)
    XCTAssertEqual(record.minimumMacOS, "RestoreImage-23A344")
    XCTAssertEqual(record.includedSwiftVersion, "SwiftVersion-5.9.2")
    XCTAssertNotNil(record.sdkVersions)
  }

  internal func testRecordName() {
    let record = makeSampleRecord()
    XCTAssertEqual(record.recordName, "XcodeVersion-15C65")
  }

  internal func testBetaVersion() {
    let beta = XcodeVersionRecord(
      version: "15.2 Beta 3",
      buildNumber: "15C5500c",
      releaseDate: Date(),
      isPrerelease: true
    )

    XCTAssertTrue(beta.isPrerelease)
    XCTAssertTrue(beta.version.contains("Beta"))
  }

  internal func testCodableRoundTrip() throws {
    let original = makeSampleRecord()

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    let encoded = try encoder.encode(original)
    let decoded = try decoder.decode(XcodeVersionRecord.self, from: encoded)

    XCTAssertEqual(decoded.version, original.version)
    XCTAssertEqual(decoded.buildNumber, original.buildNumber)
    XCTAssertEqual(decoded.downloadURL, original.downloadURL)
    XCTAssertEqual(decoded.fileSize, original.fileSize)
    XCTAssertEqual(decoded.isPrerelease, original.isPrerelease)
    XCTAssertEqual(decoded.minimumMacOS, original.minimumMacOS)
    XCTAssertEqual(decoded.includedSwiftVersion, original.includedSwiftVersion)
    XCTAssertEqual(decoded.sdkVersions, original.sdkVersions)
  }

  internal func testOptionalFields() {
    let minimal = XcodeVersionRecord(
      version: "14.0",
      buildNumber: "14A309",
      releaseDate: Date(),
      isPrerelease: false
    )

    XCTAssertNil(minimal.downloadURL)
    XCTAssertNil(minimal.fileSize)
    XCTAssertNil(minimal.minimumMacOS)
    XCTAssertNil(minimal.includedSwiftVersion)
    XCTAssertNil(minimal.sdkVersions)
    XCTAssertNil(minimal.notes)
  }
}
