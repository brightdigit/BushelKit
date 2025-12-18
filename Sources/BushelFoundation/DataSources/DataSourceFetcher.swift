//
//  DataSourceFetcher.swift
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
/// - Should use `URLSession.fetchData()` or `URLSession.fetchLastModified()` to track source freshness
/// - Should handle network errors gracefully and provide meaningful error messages
///
/// ## Example Implementation
/// ```swift
/// struct MyFetcher: DataSourceFetcher {
///     func fetch() async throws -> [MyRecord] {
///         let url = URL(string: "https://api.example.com/data")!
///         let (data, lastModified) = try await URLSession.shared.fetchData(from: url)
///         let items = try JSONDecoder().decode([Item].self, from: data, source: "api.example.com")
///         return items.map { MyRecord(from: $0, lastModified: lastModified) }
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
