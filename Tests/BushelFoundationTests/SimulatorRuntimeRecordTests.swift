//
//  SimulatorRuntimeRecordTests.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2026 BrightDigit.
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

internal final class SimulatorRuntimeRecordTests: XCTestCase {
  private typealias ReleaseLabel = SimulatorRuntimeRecord.ReleaseLabel

  // Real 27.2 builds from Apple's simulator index (2026-11-17).
  private static let releaseCandidate = SimulatorRuntimeRecord(
    platform: .iOS,
    version: "27.2",
    buildNumber: "24B114",
    releaseLabel: .releaseCandidate(1),
    sdkBuildNumbers: ["24B113"]
  )

  private static let duoFinal = SimulatorRuntimeRecord(
    platform: .iOS,
    version: "27.2",
    buildNumber: "24B91016s",
    releaseLabel: .final,
    sdkBuildNumbers: ["24B113", "24B8118"]
  )

  private static let minimal = SimulatorRuntimeRecord(
    platform: .watchOS,
    version: "27.2",
    buildNumber: "24S5086l",
    releaseLabel: .beta(1)
  )

  internal func testInitialization() {
    let record = Self.releaseCandidate

    XCTAssertEqual(record.platform, .iOS)
    XCTAssertEqual(record.version, "27.2")
    XCTAssertEqual(record.buildNumber, "24B114")
    XCTAssertEqual(record.releaseLabel, .releaseCandidate(1))
    XCTAssertEqual(record.sdkBuildNumbers, ["24B113"])
    XCTAssertTrue(record.isPrerelease)
    XCTAssertTrue(Self.minimal.isPrerelease)
    XCTAssertFalse(Self.duoFinal.isPrerelease)
    XCTAssertEqual(Self.minimal.sdkBuildNumbers, [])
  }

  internal func testRecordName() {
    XCTAssertEqual(Self.releaseCandidate.recordName, "SimulatorRuntime-iOS-24B114")
    XCTAssertEqual(Self.duoFinal.recordName, "SimulatorRuntime-iOS-24B91016s")
    XCTAssertEqual(Self.minimal.recordName, "SimulatorRuntime-watchOS-24S5086l")
  }

  internal func testCodableRoundTrip() throws {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    for original in [Self.releaseCandidate, Self.duoFinal, Self.minimal] {
      let encoded = try encoder.encode(original)
      let decoded = try decoder.decode(SimulatorRuntimeRecord.self, from: encoded)
      XCTAssertEqual(decoded, original)
    }
  }

  internal func testLabelEncodesAsText() throws {
    let encoded = try JSONEncoder().encode(Self.releaseCandidate)
    let object = try XCTUnwrap(
      JSONSerialization.jsonObject(with: encoded) as? [String: Any]
    )
    XCTAssertEqual(object["releaseLabel"] as? String, "RC 1")
    XCTAssertNil(object["isPrerelease"])
    XCTAssertNil(object["recordName"])
  }

  internal func testLabelOrder() {
    let ordered: [ReleaseLabel] = [
      .beta(1), .beta(2), .beta(10), .releaseCandidate(1), .releaseCandidate(2), .final,
    ]
    XCTAssertEqual(ordered.shuffled().sorted(), ordered)
    for (lower, higher) in zip(ordered, ordered.dropFirst()) {
      XCTAssertLessThan(lower, higher)
      XCTAssertFalse(higher < lower)
    }
    XCTAssertFalse(ReleaseLabel.beta(3) < .beta(3))
  }

  internal func testLabelText() {
    let labels: [String: ReleaseLabel] = [
      "Beta 1": .beta(1),
      "Beta 12": .beta(12),
      "RC 1": .releaseCandidate(1),
      "RC 2": .releaseCandidate(2),
      "Final": .final,
    ]
    for (text, label) in labels {
      XCTAssertEqual(label.description, text)
      XCTAssertEqual(ReleaseLabel(text), label)
    }
  }

  internal func testInvalidLabelText() {
    for text in ["", "Beta", "Beta 0", "RC", "RC -1", "beta 1", "Beta 1 ", "GM", "final"] {
      XCTAssertNil(ReleaseLabel(text), text)
    }
  }

  internal func testInvalidLabelFailsToDecode() throws {
    let encoded = try JSONEncoder().encode(Self.minimal)
    var object = try XCTUnwrap(
      JSONSerialization.jsonObject(with: encoded) as? [String: Any]
    )
    object["releaseLabel"] = "Seed 4"
    let modified = try JSONSerialization.data(withJSONObject: object)

    XCTAssertThrowsError(
      try JSONDecoder().decode(SimulatorRuntimeRecord.self, from: modified)
    )
  }
}
