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

      // With improved error handling, this should be .keyNotFound, not .dataCorrupted
      if case DecodingError.keyNotFound(let key, let context) = error {
        XCTAssertEqual(key.stringValue, "value")
        XCTAssertTrue(context.debugDescription.contains("[test.source]"))
      } else if case DecodingError.dataCorrupted(let context) = error {
        // Fallback for potential different behavior
        XCTAssertTrue(context.debugDescription.contains("[test.source]"))
      }
    }
  }

  // MARK: - Coding Path Preservation Tests

  internal struct NestedModel: Codable {
    internal let nested: TestModel
  }

  internal func testPreservesCodingPathForTypeMismatch() throws {
    let json = #"{"nested": {"name": "test", "value": "not-a-number"}}"#
    let data = try XCTUnwrap(json.data(using: .utf8))

    let decoder = JSONDecoder()

    XCTAssertThrowsError(
      try decoder.decode(
        NestedModel.self,
        from: data,
        source: "api.example.com"
      )
    ) { error in
      guard case DecodingError.typeMismatch(_, let context) = error else {
        XCTFail("Expected typeMismatch error, got \(error)")
        return
      }

      // Verify coding path is preserved
      XCTAssertEqual(context.codingPath.count, 2)
      XCTAssertEqual(context.codingPath[0].stringValue, "nested")
      XCTAssertEqual(context.codingPath[1].stringValue, "value")

      // Verify source is included in description
      XCTAssertTrue(context.debugDescription.contains("[api.example.com]"))
    }
  }

  internal func testPreservesCodingPathForKeyNotFound() throws {
    let json = #"{"nested": {"name": "test"}}"#  // Missing 'value' in nested
    let data = try XCTUnwrap(json.data(using: .utf8))

    let decoder = JSONDecoder()

    XCTAssertThrowsError(
      try decoder.decode(
        NestedModel.self,
        from: data,
        source: "api.example.com"
      )
    ) { error in
      guard case DecodingError.keyNotFound(let key, let context) = error else {
        XCTFail("Expected keyNotFound error, got \(error)")
        return
      }

      // Verify the missing key
      XCTAssertEqual(key.stringValue, "value")

      // Verify coding path is preserved (path to container where key is missing)
      XCTAssertEqual(context.codingPath.count, 1)
      XCTAssertEqual(context.codingPath[0].stringValue, "nested")

      // Verify source is included in description
      XCTAssertTrue(context.debugDescription.contains("[api.example.com]"))
    }
  }

  internal struct OptionalModel: Codable {
    internal let required: String
    internal let optional: String?
  }

  internal func testPreservesCodingPathForValueNotFound() throws {
    // Create JSON with explicit null for a non-optional field
    let json = #"{"required": null}"#
    let data = try XCTUnwrap(json.data(using: .utf8))

    let decoder = JSONDecoder()

    XCTAssertThrowsError(
      try decoder.decode(
        OptionalModel.self,
        from: data,
        source: "api.example.com"
      )
    ) { error in
      guard case DecodingError.valueNotFound(_, let context) = error else {
        XCTFail("Expected valueNotFound error, got \(error)")
        return
      }

      // Verify coding path is preserved
      XCTAssertEqual(context.codingPath.count, 1)
      XCTAssertEqual(context.codingPath[0].stringValue, "required")

      // Verify source is included in description
      XCTAssertTrue(context.debugDescription.contains("[api.example.com]"))
    }
  }

  internal func testPreservesCodingPathForDataCorrupted() throws {
    let invalidJSON = "{"
    let data = try XCTUnwrap(invalidJSON.data(using: .utf8))

    let decoder = JSONDecoder()

    XCTAssertThrowsError(
      try decoder.decode(
        TestModel.self,
        from: data,
        source: "api.example.com"
      )
    ) { error in
      guard case DecodingError.dataCorrupted(let context) = error else {
        XCTFail("Expected dataCorrupted error, got \(error)")
        return
      }

      // Verify source is included in description
      XCTAssertTrue(context.debugDescription.contains("[api.example.com]"))
    }
  }

  // MARK: - Non-DecodingError Handling

  internal struct CustomError: Error {
    internal let message: String
  }

  internal struct FailingDecodable: Codable {
    internal init(from decoder: Decoder) throws {
      // Throw a non-DecodingError
      throw CustomError(message: "Custom error")
    }

    internal func encode(to encoder: Encoder) throws {
      // Not used in tests
    }
  }

  internal func testHandlesNonDecodingError() throws {
    let json = #"{}"#
    let data = try XCTUnwrap(json.data(using: .utf8))

    let decoder = JSONDecoder()

    XCTAssertThrowsError(
      try decoder.decode(
        FailingDecodable.self,
        from: data,
        source: "api.example.com"
      )
    ) { error in
      // Should be wrapped in DecodingError.dataCorrupted
      guard case DecodingError.dataCorrupted(let context) = error else {
        XCTFail("Expected dataCorrupted wrapping non-DecodingError, got \(error)")
        return
      }

      // Verify source is included
      XCTAssertTrue(context.debugDescription.contains("[api.example.com]"))

      // Verify it mentions it's wrapping another error
      XCTAssertTrue(context.debugDescription.contains("Failed to decode"))
    }
  }

  // MARK: - Source Context Tests

  internal func testSourceContextInAllErrorTypes() throws {
    let sources = ["ipsw.me", "appledb.dev", "github.com"]

    for source in sources {
      let json = #"{"name": "test"}"#
      let data = try XCTUnwrap(json.data(using: .utf8))

      let decoder = JSONDecoder()

      XCTAssertThrowsError(
        try decoder.decode(
          TestModel.self,
          from: data,
          source: source
        )
      ) { error in
        guard case DecodingError.keyNotFound(_, let context) = error else {
          XCTFail("Expected keyNotFound error for source \(source)")
          return
        }

        // Verify source appears in debug description
        XCTAssertTrue(
          context.debugDescription.contains("[\(source)]"),
          "Source '\(source)' not found in error description: \(context.debugDescription)"
        )
      }
    }
  }
}
