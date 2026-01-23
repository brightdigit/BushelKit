//
//  ReviewEngagementThresholdTests.swift
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

internal final class ReviewEngagementThresholdTests: XCTestCase {
  internal func testDefaultValue() {
    let defaultThreshold = ReviewEngagementThreshold.default
    XCTAssertEqual(defaultThreshold.rawValue, 10)
  }

  internal func testIntegerLiteralInit() {
    let threshold: ReviewEngagementThreshold = 15
    XCTAssertEqual(threshold.rawValue, 15)
  }

  internal func testRawValueInit() {
    let threshold = ReviewEngagementThreshold(rawValue: 20)
    XCTAssertEqual(threshold.rawValue, 20)
  }

  internal func testEnvironmentStringValueRoundTrip() {
    let threshold = ReviewEngagementThreshold(rawValue: 25)
    let stringValue = threshold.environmentStringValue
    XCTAssertEqual(stringValue, "25")

    let reconstructed = ReviewEngagementThreshold(environmentStringValue: stringValue)
    XCTAssertNotNil(reconstructed)
    XCTAssertEqual(reconstructed?.rawValue, 25)
  }

  internal func testEnvironmentStringValueInvalid() {
    let invalidStrings = ["", "abc", "10.5", "not a number"]

    for invalidString in invalidStrings {
      let result = ReviewEngagementThreshold(environmentStringValue: invalidString)
      XCTAssertNil(result, "Expected nil for invalid string: \(invalidString)")
    }
  }

  internal func testCodableRoundTrip() throws {
    let original = ReviewEngagementThreshold(rawValue: 30)

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    let encoded = try encoder.encode(original)
    let decoded = try decoder.decode(ReviewEngagementThreshold.self, from: encoded)

    XCTAssertEqual(decoded.rawValue, original.rawValue)
  }

  internal func testSendable() {
    Task {
      let threshold = ReviewEngagementThreshold(rawValue: 35)
      XCTAssertEqual(threshold.rawValue, 35)
    }
  }

  internal func testEquatable() {
    let threshold1 = ReviewEngagementThreshold(rawValue: 10)
    let threshold2 = ReviewEngagementThreshold(rawValue: 10)
    let threshold3 = ReviewEngagementThreshold(rawValue: 15)

    XCTAssertEqual(threshold1, threshold2)
    XCTAssertNotEqual(threshold1, threshold3)
  }

  internal func testZeroValue() {
    let threshold = ReviewEngagementThreshold(rawValue: 0)
    XCTAssertEqual(threshold.rawValue, 0)
  }

  internal func testNegativeValue() {
    // The type allows negative values - it's up to the caller to validate if needed
    let threshold = ReviewEngagementThreshold(rawValue: -5)
    XCTAssertEqual(threshold.rawValue, -5)
  }
}
