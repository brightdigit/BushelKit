//
//  JSONDecoderTests.swift
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

@testable import BushelUtilities

internal final class JSONDecoderTests: XCTestCase {
  internal struct TestModel: Codable, Equatable {
    internal let name: String
    internal let value: Int
  }

  internal func testDecodeSuccessful() throws {
    let json = #"{"name": "test", "value": 42}"#
    let data = try XCTUnwrap(json.data(using: .utf8))

    let decoder = JSONDecoder()
    let decoded = try decoder.decode(
      TestModel.self,
      from: data,
      source: "test.source"
    )

    XCTAssertEqual(decoded.name, "test")
    XCTAssertEqual(decoded.value, 42)
  }

  internal func testDecodeInvalidJSON() throws {
    let invalidJSON = "not valid json"
    let data = try XCTUnwrap(invalidJSON.data(using: .utf8))

    let decoder = JSONDecoder()

    XCTAssertThrowsError(
      try decoder.decode(
        TestModel.self,
        from: data,
        source: "test.source"
      )
    ) { error in
      XCTAssertTrue(error is DecodingError)

      if case DecodingError.dataCorrupted(let context) = error {
        XCTAssertTrue(context.debugDescription.contains("test.source"))
      }
    }
  }

  internal func testDecodeMissingField() throws {
    let json = #"{"name": "test"}"#  // Missing 'value'
    let data = try XCTUnwrap(json.data(using: .utf8))

    let decoder = JSONDecoder()

    XCTAssertThrowsError(
      try decoder.decode(
        TestModel.self,
        from: data,
        source: "test.source"
      )
    ) { error in
      XCTAssertTrue(error is DecodingError)

      if case DecodingError.dataCorrupted(let context) = error {
        XCTAssertTrue(context.debugDescription.contains("test.source"))
      }
    }
  }
}
