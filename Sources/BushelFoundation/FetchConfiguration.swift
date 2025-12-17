//
//  FetchConfiguration.swift
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

/// Configuration for data source fetch throttling
public struct FetchConfiguration: Codable, Sendable {
  // MARK: - Properties

  /// Global minimum interval between fetches (applies to all sources unless overridden)
  public let globalMinimumFetchInterval: TimeInterval?

  /// Per-source minimum intervals (overrides global and default intervals)
  /// Key is the source name (e.g., "appledb.dev", "ipsw.me")
  public let perSourceIntervals: [String: TimeInterval]

  /// Whether to use default intervals for known sources
  public let useDefaults: Bool

  // MARK: - Initialization

  public init(
    globalMinimumFetchInterval: TimeInterval? = nil,
    perSourceIntervals: [String: TimeInterval] = [:],
    useDefaults: Bool = true
  ) {
    self.globalMinimumFetchInterval = globalMinimumFetchInterval
    self.perSourceIntervals = perSourceIntervals
    self.useDefaults = useDefaults
  }

  // MARK: - Methods

  /// Get the minimum fetch interval for a specific source
  /// - Parameter source: The source name (e.g., "appledb.dev")
  /// - Returns: The minimum interval in seconds, or nil if no restrictions
  public func minimumInterval(for source: String) -> TimeInterval? {
    // Priority: per-source > global > defaults
    if let perSourceInterval = perSourceIntervals[source] {
      return perSourceInterval
    }

    if let globalInterval = globalMinimumFetchInterval {
      return globalInterval
    }

    if useDefaults {
      return Self.defaultIntervals[source]
    }

    return nil
  }

  /// Should this source be fetched given the last fetch time?
  /// - Parameters:
  ///   - source: The source name
  ///   - lastFetchedAt: When the source was last fetched (nil means never fetched)
  ///   - force: Whether to ignore intervals and fetch anyway
  ///   - currentDate: Current date/time for comparison (defaults to Date())
  /// - Returns: True if the source should be fetched
  public func shouldFetch(
    source: String,
    lastFetchedAt: Date?,
    force: Bool = false,
    currentDate: Date = Date()
  ) -> Bool {
    // Always fetch if force flag is set
    if force {
      return true
    }

    // Always fetch if never fetched before
    guard let lastFetch = lastFetchedAt else {
      return true
    }

    // Check if enough time has passed since last fetch
    guard let minInterval = minimumInterval(for: source) else {
      return true
    }

    let timeSinceLastFetch = currentDate.timeIntervalSince(lastFetch)
    return timeSinceLastFetch >= minInterval
  }

  // MARK: - Default Intervals

  /// Default minimum intervals for known sources (in seconds)
  ///
  /// Generated from DataSource enum to ensure type safety and consistency.
  public static let defaultIntervals: [String: TimeInterval] =
    Dictionary(
      uniqueKeysWithValues: DataSource.allCases.map { ($0.rawValue, $0.defaultInterval) }
    )

  // MARK: - Factory Methods

  /// Load configuration from environment variables
  /// - Returns: Configuration with values from environment, or defaults
  public static func loadFromEnvironment() -> FetchConfiguration {
    let processInfo = ProcessInfo.processInfo

    return FetchConfiguration(
      globalMinimumFetchInterval: processInfo.globalFetchInterval(),
      perSourceIntervals: processInfo.fetchIntervals(),
      useDefaults: true
    )
  }
}
