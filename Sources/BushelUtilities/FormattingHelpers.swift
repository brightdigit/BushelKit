//
//  FormattingHelpers.swift
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

/// Shared formatting utilities for display output
public enum FormattingHelpers {
  /// Format a date for display (date only, no time)
  /// - Parameter date: The date to format
  /// - Returns: A formatted date string (e.g., "Jan 15, 2025")
  public static func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
  }

  /// Format a date and time for display
  /// - Parameter date: The date to format
  /// - Returns: A formatted date and time string (e.g., "Jan 15, 2025 at 3:45 PM")
  public static func formatDateTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
  }

  /// Format a byte count as a human-readable file size
  /// - Parameter bytes: The file size in bytes
  /// - Returns: A formatted size string (e.g., "1.23 GB" or "456 MB")
  public static func formatFileSize(_ bytes: Int) -> String {
    let gigabytes = Double(bytes) / 1_000_000_000
    if gigabytes >= 1.0 {
      return String(format: "%.2f GB", gigabytes)
    } else {
      let megabytes = Double(bytes) / 1_000_000
      return String(format: "%.0f MB", megabytes)
    }
  }
}
