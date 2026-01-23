//
//  DataSourceMetadata.swift
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

/// Metadata about when a data source was last fetched and updated
public struct DataSourceMetadata: Codable, Sendable {
  // MARK: Public

  /// The name of the data source (e.g., "appledb.dev", "ipsw.me")
  public let sourceName: String

  /// The type of records this source provides (e.g., "RestoreImage", "XcodeVersion")
  public let recordTypeName: String

  /// When we last fetched data from this source
  public let lastFetchedAt: Date

  /// When the source last updated its data (from HTTP Last-Modified or API metadata)
  public let sourceUpdatedAt: Date?

  /// Number of records retrieved from this source
  public let recordCount: Int

  /// How long the fetch operation took in seconds
  public let fetchDurationSeconds: Double

  /// Last error message if the fetch failed
  public let lastError: String?

  /// CloudKit record name for this metadata entry
  public var recordName: String {
    "metadata-\(sourceName)-\(recordTypeName)"
  }

  // MARK: Lifecycle

  public init(
    sourceName: String,
    recordTypeName: String,
    lastFetchedAt: Date,
    sourceUpdatedAt: Date? = nil,
    recordCount: Int = 0,
    fetchDurationSeconds: Double = 0,
    lastError: String? = nil
  ) {
    // Validation using precondition (fail-fast approach)
    precondition(!sourceName.isEmpty, "sourceName cannot be empty")
    precondition(!recordTypeName.isEmpty, "recordTypeName cannot be empty")
    precondition(
      sourceName.unicodeScalars.allSatisfy { $0.isASCII },
      "sourceName must contain only ASCII characters: \(sourceName)"
    )
    precondition(
      recordTypeName.unicodeScalars.allSatisfy { $0.isASCII },
      "recordTypeName must contain only ASCII characters: \(recordTypeName)"
    )

    let recordName = "metadata-\(sourceName)-\(recordTypeName)"
    precondition(
      recordName.count <= 255,
      "CloudKit record name exceeds 255 characters: \(recordName.count)"
    )

    precondition(recordCount >= 0, "recordCount cannot be negative: \(recordCount)")
    precondition(
      fetchDurationSeconds >= 0,
      "fetchDurationSeconds cannot be negative: \(fetchDurationSeconds)"
    )

    self.sourceName = sourceName
    self.recordTypeName = recordTypeName
    self.lastFetchedAt = lastFetchedAt
    self.sourceUpdatedAt = sourceUpdatedAt
    self.recordCount = recordCount
    self.fetchDurationSeconds = fetchDurationSeconds
    self.lastError = lastError
  }

  /// Validates DataSourceMetadata parameters without creating an instance.
  ///
  /// - Parameters:
  ///   - sourceName: The data source name
  ///   - recordTypeName: The record type name
  ///   - recordCount: Number of records
  ///   - fetchDurationSeconds: Fetch duration in seconds
  /// - Throws: `DataSourceMetadataValidationError` if validation fails
  public static func validate(
    sourceName: String,
    recordTypeName: String,
    recordCount: Int,
    fetchDurationSeconds: Double
  ) throws {
    try validateNames(sourceName: sourceName, recordTypeName: recordTypeName)
    try validateNumericFields(recordCount: recordCount, fetchDurationSeconds: fetchDurationSeconds)
  }

  private static func validateNames(sourceName: String, recordTypeName: String) throws {
    if sourceName.isEmpty {
      throw DataSourceMetadataValidationError(details: .emptySourceName)
    }
    if recordTypeName.isEmpty {
      throw DataSourceMetadataValidationError(details: .emptyRecordTypeName)
    }
    if !sourceName.unicodeScalars.allSatisfy({ $0.isASCII }) {
      throw DataSourceMetadataValidationError(details: .nonASCIISourceName(sourceName))
    }
    if !recordTypeName.unicodeScalars.allSatisfy({ $0.isASCII }) {
      throw DataSourceMetadataValidationError(details: .nonASCIIRecordTypeName(recordTypeName))
    }

    let recordName = "metadata-\(sourceName)-\(recordTypeName)"
    if recordName.count > 255 {
      throw DataSourceMetadataValidationError(details: .recordNameTooLong(recordName.count))
    }
  }

  private static func validateNumericFields(
    recordCount: Int,
    fetchDurationSeconds: Double
  ) throws {
    if recordCount < 0 {
      throw DataSourceMetadataValidationError(details: .negativeRecordCount(recordCount))
    }
    if fetchDurationSeconds < 0 {
      throw DataSourceMetadataValidationError(details: .negativeFetchDuration(fetchDurationSeconds))
    }
  }
}
