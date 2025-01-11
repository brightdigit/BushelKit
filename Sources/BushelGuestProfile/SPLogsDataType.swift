//
//  SPLogsDataType.swift
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

/// Represents a data type for storing logs.
public struct SPLogsDataType: Codable, Equatable, Sendable {
  /// The coding keys used for encoding and decoding the `SPLogsDataType` struct.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case byteSize
    case contents
    case lastModified
    case source
  }

  /// The name of the log data.
  public let name: String
  /// The byte size of the log data.
  public let byteSize: Int
  /// The contents of the log data.
  public let contents: String
  /// The last modified date of the log data.
  public let lastModified: Date?
  /// The source of the log data.
  public let source: String

  /// Initializes a new instance of `SPLogsDataType`.
  /// - Parameters:
  ///   - name: The name of the log data.
  ///   - byteSize: The byte size of the log data.
  ///   - contents: The contents of the log data.
  ///   - lastModified: The last modified date of the log data.
  ///   - source: The source of the log data.
  public init(
    name: String,
    byteSize: Int,
    contents: String,
    lastModified: Date?,
    source: String
  ) {
    self.name = name
    self.byteSize = byteSize
    self.contents = contents
    self.lastModified = lastModified
    self.source = source
  }
}
