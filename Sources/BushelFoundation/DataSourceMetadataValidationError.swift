//
//  DataSourceMetadataValidationError.swift
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

/// Validation errors for DataSourceMetadata.
public struct DataSourceMetadataValidationError: Error, Sendable {
  /// Specific validation error details.
  public enum Details: Equatable, Sendable {
    /// The source name is empty.
    case emptySourceName
    /// The record type name is empty.
    case emptyRecordTypeName
    /// The source name contains non-ASCII characters.
    case nonASCIISourceName(String)
    /// The record type name contains non-ASCII characters.
    case nonASCIIRecordTypeName(String)
    /// The generated CloudKit record name exceeds 255 characters.
    case recordNameTooLong(Int)
    /// The record count is negative.
    case negativeRecordCount(Int)
    /// The fetch duration is negative.
    case negativeFetchDuration(Double)
  }

  /// The specific validation error.
  public let details: Details

  /// Creates a new validation error.
  /// - Parameter details: The specific validation error details.
  public init(details: Details) {
    self.details = details
  }
}
