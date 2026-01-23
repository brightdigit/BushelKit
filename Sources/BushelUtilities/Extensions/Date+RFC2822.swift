//
//  Date+RFC2822.swift
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

extension Date {
  /// RFC 2822 parse strategy for HTTP Last-Modified headers
  ///
  /// Thread-safe parse strategy using modern Swift FormatStyle API.
  /// Format: "EEE, dd MMM yyyy HH:mm:ss zzz"
  private static let rfc2822ParseStrategy = Date.ParseStrategy(
    format:
      "\(weekday: .abbreviated), \(day: .twoDigits) \(month: .abbreviated) \(year: .padded(4)) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) GMT",
    locale: Locale(identifier: "en_US_POSIX"),
    timeZone: TimeZone(secondsFromGMT: 0) ?? .gmt
  )

  /// Creates a date from an RFC 2822 formatted string
  ///
  /// This initializer is designed for HTTP Last-Modified headers and similar RFC 2822 date formats.
  /// Uses modern thread-safe ParseStrategy API for parsing.
  ///
  /// Example: "Fri, 19 Dec 2025 10:30:45 GMT"
  ///
  /// - Parameter rfc2822String: The RFC 2822 formatted date string
  /// - Returns: A date if parsing succeeds, nil otherwise
  public init?(rfc2822String: String) {
    do {
      self = try Self.rfc2822ParseStrategy.parse(rfc2822String)
    } catch {
      return nil
    }
  }
}
