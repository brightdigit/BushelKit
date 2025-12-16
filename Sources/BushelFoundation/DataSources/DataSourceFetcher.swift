//
//  DataSourceFetcher.swift
//  BushelCloud
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

public import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// Protocol for data source fetchers that retrieve records from external APIs
///
/// This protocol provides a common interface for all data source fetchers in the Bushel pipeline.
/// Fetchers are responsible for retrieving data from external sources and converting them to
/// typed record models.
///
/// ## Implementation Requirements
/// - Must be `Sendable` to support concurrent fetching
/// - Should use `HTTPHeaderHelpers.fetchLastModified()` when available to track source freshness
/// - Should handle network errors gracefully and provide meaningful error messages
///
/// ## Example Implementation
/// ```swift
/// struct MyFetcher: DataSourceFetcher {
///     func fetch() async throws -> [MyRecord] {
///         let url = URL(string: "https://api.example.com/data")!
///         let (data, _) = try await URLSession.shared.data(from: url)
///         let items = try JSONDecoder().decode([Item].self, from: data)
///         return items.map { MyRecord(from: $0) }
///     }
/// }
/// ```
public protocol DataSourceFetcher: Sendable {
  /// The type of records this fetcher produces
  associatedtype Record

  /// Fetch records from the external data source
  ///
  /// - Returns: Collection of records fetched from the source
  /// - Throws: Errors related to network requests, parsing, or data validation
  func fetch() async throws -> Record
}

/// Common utilities for data source fetchers
public enum DataSourceUtilities {
  /// Fetch data from a URL with optional Last-Modified header tracking
  ///
  /// This helper combines data fetching with Last-Modified header extraction,
  /// allowing fetchers to track when their source data was last updated.
  ///
  /// - Parameters:
  ///   - url: The URL to fetch from
  ///   - trackLastModified: Whether to make a HEAD request to get Last-Modified (default: true)
  /// - Returns: Tuple of (data, lastModified date or nil)
  /// - Throws: Errors from URLSession or network issues
  public static func fetchData(
    from url: URL,
    trackLastModified: Bool = true
  ) async throws -> (Data, Date?) {
    let lastModified =
      trackLastModified ? await HTTPHeaderHelpers.fetchLastModified(from: url) : nil
    let (data, _) = try await URLSession.shared.data(from: url)
    return (data, lastModified)
  }

  /// Decode JSON data
  ///
  /// - Parameters:
  ///   - type: The type to decode to
  ///   - data: The JSON data to decode
  ///   - source: Source name (unused, kept for API compatibility)
  /// - Returns: Decoded object
  /// - Throws: DecodingError with context
  public static func decodeJSON<T: Decodable>(
    _ type: T.Type,
    from data: Data,
    source: String
  ) throws -> T {
    try JSONDecoder().decode(type, from: data)
  }
}
