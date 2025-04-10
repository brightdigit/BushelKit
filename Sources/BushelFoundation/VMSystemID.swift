//
//  VMSystemID.swift
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

internal import Foundation

/// A type-safe wrapper around a string that represents a virtual machine system ID.
public struct VMSystemID:
  ExpressibleByStringInterpolation,
  Codable,
  Hashable,
  RawRepresentable,
  Sendable
{
  /// The underlying string value.
  public let rawValue: String

  /// Initializes a `VMSystemID` with the specified raw value.
  ///
  /// - Parameter value: The raw string value to use.
  public init(rawValue value: String) {
    self.rawValue = value
  }

  /// Initializes a `VMSystemID` from a string literal.
  ///
  /// - Parameter value: The string literal to use.
  public init(stringLiteral value: String) {
    self.rawValue = value
  }

  /// Initializes a `VMSystemID` by decoding a string from the given decoder.
  ///
  /// - Parameter decoder: The decoder to use for decoding the string.
  /// - Throws: Any errors that occur during the decoding process.
  public init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.rawValue = try container.decode(String.self)
  }

  /// Encodes the `VMSystemID` instance to the given encoder.
  ///
  /// - Parameter encoder: The encoder to use for encoding the `VMSystemID`.
  /// - Throws: Any errors that occur during the encoding process.
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
