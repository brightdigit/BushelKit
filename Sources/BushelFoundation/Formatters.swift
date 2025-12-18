//
//  Formatters.swift
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

/// A collection of pre-configured date formatters.
public enum Formatters {
  #if os(macOS)
    /// A date components formatter that displays time in a seconds-based format (e.g. "1m 30s").
    public static let seconds: DateComponentsFormatter = {
      let secondsFormatter = DateComponentsFormatter()
      secondsFormatter.allowedUnits = [.minute, .second]
      secondsFormatter.zeroFormattingBehavior = .dropAll
      secondsFormatter.allowsFractionalUnits = true
      secondsFormatter.unitsStyle = .abbreviated
      return secondsFormatter
    }()
  #endif

  #if canImport(FoundationNetworking)
    /// A date formatter that parses and formats dates in the "E, d MMM yyyy HH:mm:ss Z" format.
    ///
    /// - Parameter dateFormat: The date format string to use.
    /// - Returns: A date formatter configured with the provided date format.
    nonisolated(unsafe) public static let lastModifiedDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
      return formatter
    }()

    /// A date formatter that displays dates and times
    /// in a medium-length format (e.g. "Jan 1, 2023, 12:00:00 AM").
    nonisolated(unsafe) public static let snapshotDateFormatter = {
      var formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .medium
      return formatter
    }()

    /// A date formatter that displays dates in a long format (e.g. "January 1, 2023").
    nonisolated(unsafe) public static let longDate: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = .long
      dateFormatter.timeStyle = .none
      return dateFormatter
    }()
  #else
    /// A date formatter that parses and formats dates in the "E, d MMM yyyy HH:mm:ss Z" format.
    ///
    /// - Parameter dateFormat: The date format string to use.
    /// - Returns: A date formatter configured with the provided date format.
    public static let lastModifiedDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
      return formatter
    }()

    /// A date formatter that displays dates and times in a medium-length format.
    public static let snapshotDateFormatter = {
      var formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .medium
      return formatter
    }()

    /// A date formatter that displays dates in a long format (e.g. "January 1, 2023").
    public static let longDate: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = .long
      dateFormatter.timeStyle = .none
      return dateFormatter
    }()
  #endif
}
