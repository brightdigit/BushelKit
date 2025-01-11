//
//  SPSyncServicesDataTypeItem.swift
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

/// Represents an item in the SPSyncServicesDataType.
public struct SPSyncServicesDataTypeItem: Codable, Equatable, Sendable {
  /// The coding keys for the struct.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case summaryOfSyncLog = "summary_of_sync_log"
    case contents
    case description
    case lastModified
    case size
  }

  /// The name of the item.
  public let name: String
  /// The summary of the sync log for the item.
  public let summaryOfSyncLog: String?
  /// The contents of the item.
  public let contents: String?
  /// The description of the item.
  public let description: String?
  /// The last modified date of the item.
  public let lastModified: Date?
  /// The size of the item.
  public let size: String?

  /// Initializes a new `SPSyncServicesDataTypeItem` instance.
  ///
  /// - Parameters:
  ///   - name: The name of the item.
  ///   - summaryOfSyncLog: The summary of the sync log for the item.
  ///   - contents: The contents of the item.
  ///   - description: The description of the item.
  ///   - lastModified: The last modified date of the item.
  ///   - size: The size of the item.
  public init(
    name: String,
    summaryOfSyncLog: String?,
    contents: String?,
    description: String?,
    lastModified: Date?,
    size: String?
  ) {
    self.name = name
    self.summaryOfSyncLog = summaryOfSyncLog
    self.contents = contents
    self.description = description
    self.lastModified = lastModified
    self.size = size
  }
}
