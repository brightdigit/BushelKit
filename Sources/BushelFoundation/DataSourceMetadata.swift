//
//  DataSourceMetadata.swift
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

/// Metadata about when a data source was last fetched and updated
public struct DataSourceMetadata: Codable, Sendable {
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
    self.sourceName = sourceName
    self.recordTypeName = recordTypeName
    self.lastFetchedAt = lastFetchedAt
    self.sourceUpdatedAt = sourceUpdatedAt
    self.recordCount = recordCount
    self.fetchDurationSeconds = fetchDurationSeconds
    self.lastError = lastError
  }

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
}
