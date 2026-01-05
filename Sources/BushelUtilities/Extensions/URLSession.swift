//
//  URLSession.swift
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
  public import FoundationNetworking
#endif

extension URLSession {
  /// Fetch data from a URL with optional Last-Modified header tracking and HTTP validation
  ///
  /// This method combines data fetching with Last-Modified header extraction and HTTP response validation,
  /// allowing callers to track when source data was last updated while ensuring valid responses.
  ///
  /// - Parameters:
  ///   - url: The URL to fetch from
  ///   - trackLastModified: Whether to extract Last-Modified from response headers (default: true)
  /// - Returns: HTTPFetchResult containing the data and optional last modified date
  /// - Throws: URLError if request fails, response is invalid, or HTTP status is not 200-299
  public func fetchData(
    from url: URL,
    trackLastModified: Bool = true
  ) async throws -> HTTPFetchResult {
    let (data, response) = try await data(from: url)

    // Validate HTTP response
    guard let httpResponse = response as? HTTPURLResponse else {
      throw URLError(.badServerResponse)
    }

    guard (200...299).contains(httpResponse.statusCode) else {
      throw URLError(
        .badServerResponse,
        userInfo: [
          NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode): Request failed"
        ]
      )
    }

    // Extract Last-Modified header if requested
    let lastModified = trackLastModified ? httpResponse.lastModified : nil

    return HTTPFetchResult(data: data, lastModified: lastModified)
  }

  /// Fetches the Last-Modified header from a URL using a HEAD request
  ///
  /// - Parameter url: The URL to fetch the header from
  /// - Returns: The Last-Modified date, or nil if not available or on error
  public func fetchLastModified(from url: URL) async -> Date? {
    do {
      var request = URLRequest(url: url)
      request.httpMethod = "HEAD"

      let (_, response) = try await data(for: request)

      guard let httpResponse = response as? HTTPURLResponse,
        let lastModifiedString = httpResponse.value(forHTTPHeaderField: "Last-Modified")
      else {
        return nil
      }

      return Self.parseLastModifiedDate(from: lastModifiedString)
    } catch {
      return nil
    }
  }

  /// Parses a Last-Modified header value in RFC 2822 format
  ///
  /// - Parameter dateString: The date string from the header
  /// - Returns: The parsed date, or nil if parsing fails
  private static func parseLastModifiedDate(from dateString: String) -> Date? {
    Date(rfc2822String: dateString)
  }
}
