//
//  SPSyncServicesDataTypeItem.swift
//  Sublimation
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

// MARK: - SPSyncServicesDataTypeItem

public struct SPSyncServicesDataTypeItem: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case summaryOfSyncLog = "summary_of_sync_log"
    case contents
    case description
    case lastModified
    case size
  }

  public let name: String
  public let summaryOfSyncLog: String?
  public let contents: String?
  public let description: String?
  public let lastModified: Date?
  public let size: String?

  // swiftlint:disable:next line_length
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
