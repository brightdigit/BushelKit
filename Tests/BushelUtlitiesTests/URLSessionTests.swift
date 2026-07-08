//
//  URLSessionTests.swift
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

// Skip network tests on Android due to SSL certificate issues in emulator
#if !os(Android)
  import XCTest

  @testable import BushelUtilities

  #if canImport(FoundationNetworking)
    import FoundationNetworking
  #endif

  /// Tests for URLSession extensions that provide data fetching capabilities.
  /// These tests validate the core functionality without requiring network access.
  internal final class URLSessionTests: XCTestCase {
    internal func testFetchLastModifiedWithInvalidURL() async throws {
      let url = try XCTUnwrap(
        URL(string: "https://this-domain-definitely-does-not-exist-12345.com")
      )

      let lastModified = await URLSession.shared.fetchLastModified(from: url)

      // Should return nil on error
      XCTAssertNil(lastModified)
    }

    internal func testFetchDataWithInvalidURLThrows() async throws {
      let url = try XCTUnwrap(URL(string: "https://this-definitely-does-not-exist-12345.com"))

      do {
        _ = try await URLSession.shared.fetchData(from: url)
        XCTFail("Should have thrown an error")
      } catch {
        // Expected
        XCTAssertTrue(error is URLError)
      }
    }
  }
#endif
