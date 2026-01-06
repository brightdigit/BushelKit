//
//  ProcessInfo.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

public import Foundation

extension ProcessInfo {
  /// Load per-source fetch intervals from environment variables
  ///
  /// Checks for environment variables in the format:
  /// `BUSHEL_FETCH_INTERVAL_<SOURCE>` where SOURCE is the uppercased
  /// source identifier with dots replaced by underscores.
  ///
  /// - Returns: Dictionary mapping source identifiers to intervals
  public func fetchIntervals() -> [String: TimeInterval] {
    var intervals: [String: TimeInterval] = [:]

    // Check for per-source environment variables
    for source in DataSource.allCases {
      if let intervalString = environment[source.environmentKey],
        let interval = TimeInterval(intervalString)
      {
        intervals[source.rawValue] = interval
      }
    }

    return intervals
  }

  /// Load global fetch interval from environment
  ///
  /// - Returns: Global interval if BUSHEL_FETCH_INTERVAL_GLOBAL is set
  public func globalFetchInterval() -> TimeInterval? {
    environment["BUSHEL_FETCH_INTERVAL_GLOBAL"].flatMap { TimeInterval($0) }
  }
}
