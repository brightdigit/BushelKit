//
//  HTTPHeaderHelpers.swift
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

public import BushelLogging
import Foundation

#if canImport(FelinePineSwift)
  import FelinePineSwift
#endif

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// Utilities for fetching HTTP headers from data sources
enum HTTPHeaderHelpers {
  /// Fetches the Last-Modified header from a URL
  /// - Parameter url: The URL to fetch the header from
  /// - Returns: The Last-Modified date, or nil if not available
  static func fetchLastModified(from url: URL) async -> Date? {
    do {
      var request = URLRequest(url: url)
      request.httpMethod = "HEAD"

      let (_, response) = try await URLSession.shared.data(for: request)

      guard let httpResponse = response as? HTTPURLResponse,
        let lastModifiedString = httpResponse.value(forHTTPHeaderField: "Last-Modified")
      else {
        return nil
      }

      return parseLastModifiedDate(from: lastModifiedString)
    } catch {
      Self.logger.warning(
        "Failed to fetch Last-Modified header from \(url): \(error)"
      )
      return nil
    }
  }

  /// Parses a Last-Modified header value in RFC 2822 format
  /// - Parameter dateString: The date string from the header
  /// - Returns: The parsed date, or nil if parsing fails
  private static func parseLastModifiedDate(from dateString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter.date(from: dateString)
  }
}

// MARK: - Loggable Conformance
extension HTTPHeaderHelpers: Loggable {
  static let loggingCategory: BushelLogging.Category = .hub
}
