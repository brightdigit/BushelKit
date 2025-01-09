//
//  SPSyncServicesDataType.swift
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

/// Represents a data type used in the SPSyncServices.
public struct SPSyncServicesDataType: Codable, Equatable, Sendable {
  /// The coding keys for the `SPSyncServicesDataType` struct.
  public enum CodingKeys: String, CodingKey {
    case items = "_items"
    case name = "_name"
    case summaryOSVersion = "summary_os_version"
  }

  /// The items associated with the data type.
  public let items: [SPSyncServicesDataTypeItem]
  /// The name of the data type.
  public let name: String
  /// The summary OS version associated with the data type.
  public let summaryOSVersion: String?

  /// Initializes an instance of `SPSyncServicesDataType`.
  ///
  /// - Parameters:
  ///   - items: The items associated with the data type.
  ///   - name: The name of the data type.
  ///   - summaryOSVersion: The summary OS version associated with the data type.
  public init(
    items: [SPSyncServicesDataTypeItem],
    name: String,
    summaryOSVersion: String?
  ) {
    self.items = items
    self.name = name
    self.summaryOSVersion = summaryOSVersion
  }
}
