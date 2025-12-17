//
//  FetchConfigurationTests.swift
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

internal final class FetchConfigurationTests: XCTestCase {
  // MARK: - Initialization Tests

  internal func testDefaultInitialization() {
    let config = FetchConfiguration()

    XCTAssertNil(config.globalMinimumFetchInterval)
    XCTAssertTrue(config.perSourceIntervals.isEmpty)
    XCTAssertTrue(config.useDefaults)
  }

  internal func testCustomInitialization() {
    let config = FetchConfiguration(
      globalMinimumFetchInterval: 7_200,
      perSourceIntervals: ["appledb.dev": 3_600],
      useDefaults: false
    )

    XCTAssertEqual(config.globalMinimumFetchInterval, 7_200)
    XCTAssertEqual(config.perSourceIntervals["appledb.dev"], 3_600)
    XCTAssertFalse(config.useDefaults)
  }

  // MARK: - Minimum Interval Tests

  internal func testMinimumIntervalWithPerSourceOverride() {
    let config = FetchConfiguration(
      globalMinimumFetchInterval: 7_200,
      perSourceIntervals: ["appledb.dev": 3_600],
      useDefaults: true
    )

    // Per-source takes precedence
    XCTAssertEqual(config.minimumInterval(for: "appledb.dev"), 3_600)
  }

  internal func testMinimumIntervalWithGlobal() {
    let config = FetchConfiguration(
      globalMinimumFetchInterval: 7_200,
      perSourceIntervals: [:],
      useDefaults: false
    )

    // Global applies
    XCTAssertEqual(config.minimumInterval(for: "appledb.dev"), 7_200)
  }

  internal func testMinimumIntervalWithDefaults() {
    let config = FetchConfiguration(useDefaults: true)

    // Default applies
    XCTAssertEqual(
      config.minimumInterval(for: "appledb.dev"),
      DataSource.appleDB.defaultInterval
    )
  }

  internal func testMinimumIntervalWithNoRestrictions() {
    let config = FetchConfiguration(useDefaults: false)

    XCTAssertNil(config.minimumInterval(for: "unknown.source"))
  }

  internal func testMinimumIntervalPriorityOrder() {
    // Per-source > Global > Defaults
    let config = FetchConfiguration(
      globalMinimumFetchInterval: 5_000,
      perSourceIntervals: ["appledb.dev": 1_000],
      useDefaults: true
    )

    // Per-source wins
    XCTAssertEqual(config.minimumInterval(for: "appledb.dev"), 1_000)

    // Global wins over default
    XCTAssertEqual(config.minimumInterval(for: "ipsw.me"), 5_000)
  }

  // MARK: - shouldFetch Tests

  internal func testShouldFetchWithForceFlag() {
    let config = FetchConfiguration(globalMinimumFetchInterval: 10_000)
    let lastFetch = Date(timeIntervalSinceNow: -100)  // Recent

    XCTAssertTrue(
      config.shouldFetch(
        source: "appledb.dev",
        lastFetchedAt: lastFetch,
        force: true
      )
    )
  }

  internal func testShouldFetchNeverFetched() {
    let config = FetchConfiguration(globalMinimumFetchInterval: 10_000)

    XCTAssertTrue(
      config.shouldFetch(
        source: "appledb.dev",
        lastFetchedAt: nil
      )
    )
  }

  internal func testShouldFetchIntervalNotElapsed() {
    let config = FetchConfiguration(globalMinimumFetchInterval: 3_600)
    let lastFetch = Date(timeIntervalSinceNow: -1_800)  // 30 min ago
    let currentDate = Date()

    XCTAssertFalse(
      config.shouldFetch(
        source: "appledb.dev",
        lastFetchedAt: lastFetch,
        currentDate: currentDate
      )
    )
  }

  internal func testShouldFetchIntervalElapsed() {
    let config = FetchConfiguration(globalMinimumFetchInterval: 3_600)
    let lastFetch = Date(timeIntervalSinceNow: -7_200)  // 2 hours ago
    let currentDate = Date()

    XCTAssertTrue(
      config.shouldFetch(
        source: "appledb.dev",
        lastFetchedAt: lastFetch,
        currentDate: currentDate
      )
    )
  }

  internal func testShouldFetchNoInterval() {
    let config = FetchConfiguration(useDefaults: false)
    let lastFetch = Date(timeIntervalSinceNow: -100)

    // No restrictions = always fetch
    XCTAssertTrue(
      config.shouldFetch(
        source: "unknown.source",
        lastFetchedAt: lastFetch
      )
    )
  }

  internal func testShouldFetchWithInjectedDate() {
    let config = FetchConfiguration(globalMinimumFetchInterval: 3_600)

    let lastFetch = Date(timeIntervalSince1970: 1_000)
    let currentDate = Date(timeIntervalSince1970: 5_000)  // 4000 sec later

    XCTAssertTrue(
      config.shouldFetch(
        source: "appledb.dev",
        lastFetchedAt: lastFetch,
        currentDate: currentDate
      )
    )
  }

  // MARK: - Default Intervals Tests

  internal func testDefaultIntervalsMatchEnum() {
    for source in DataSource.allCases {
      XCTAssertEqual(
        FetchConfiguration.defaultIntervals[source.rawValue],
        source.defaultInterval,
        "Default interval mismatch for \(source.rawValue)"
      )
    }
  }

  // MARK: - Codable Tests

  internal func testCodableRoundTrip() throws {
    let original = FetchConfiguration(
      globalMinimumFetchInterval: 7_200,
      perSourceIntervals: [
        "appledb.dev": 3_600,
        "ipsw.me": 1_800,
      ],
      useDefaults: false
    )

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    let encoded = try encoder.encode(original)
    let decoded = try decoder.decode(FetchConfiguration.self, from: encoded)

    XCTAssertEqual(decoded.globalMinimumFetchInterval, original.globalMinimumFetchInterval)
    XCTAssertEqual(decoded.perSourceIntervals, original.perSourceIntervals)
    XCTAssertEqual(decoded.useDefaults, original.useDefaults)
  }

  // MARK: - Environment Loading Tests

  internal func testLoadFromEnvironment() {
    // This test verifies the integration with ProcessInfo extensions
    let config = FetchConfiguration.loadFromEnvironment()

    // Should have defaults enabled
    XCTAssertTrue(config.useDefaults)
  }
}
