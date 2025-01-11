//
//  SPSmartCardsDataType.swift
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

/// Represents a data type for smart cards.
public struct SPSmartCardsDataType: Codable, Equatable, Sendable {
  /// The coding keys used for encoding and decoding the data.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case the01 = "#01"
    case items = "_items"
  }

  /// The name of the smart card data.
  public let name: String
  /// The "01" property of the smart card data.
  public let the01: String?
  /// The items associated with the smart card data.
  public let items: [SPRawCameraDataType]?

  /// Initializes a new instance of `SPSmartCardsDataType`.
  /// - Parameters:
  ///   - name: The name of the smart card data.
  ///   - the01: The "01" property of the smart card data.
  ///   - items: The items associated with the smart card data.
  public init(
    name: String,
    the01: String?,
    items: [SPRawCameraDataType]?
  ) {
    self.name = name
    self.the01 = the01
    self.items = items
  }
}
