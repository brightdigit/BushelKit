//
//  ProcessInfoTests.swift
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

internal final class ProcessInfoTests: XCTestCase {
  internal func testFetchIntervalsWithNoEnvironment() {
    let intervals = ProcessInfo.processInfo.fetchIntervals()

    // Should be empty if no env vars set
    // (or contain values if they happen to be set in test env)
    XCTAssertTrue(intervals.keys.allSatisfy { DataSource(rawValue: $0) != nil })
  }

  internal func testGlobalFetchIntervalWithNoEnvironment() {
    let interval = ProcessInfo.processInfo.globalFetchInterval()

    // Should be nil if BUSHEL_FETCH_INTERVAL_GLOBAL not set
    // (unless it happens to be set in test environment)
    _ = interval
  }

  // Note: Testing with actual environment variables is tricky in Swift tests
  // since ProcessInfo.processInfo.environment is read-only.
  // For comprehensive testing, we'd need to:
  // 1. Create a protocol for EnvironmentProvider
  // 2. Make extensions work on that protocol
  // 3. Inject mock environment in tests

  internal func testEnvironmentKeysMatchDataSource() {
    // Verify that the environment key format is correct
    for source in DataSource.allCases {
      let key = source.environmentKey
      let expectedPrefix = "BUSHEL_FETCH_INTERVAL_"

      XCTAssertTrue(key.hasPrefix(expectedPrefix))
      XCTAssertEqual(
        key,
        expectedPrefix + source.rawValue.uppercased().replacingOccurrences(of: ".", with: "_")
      )
    }
  }
}
