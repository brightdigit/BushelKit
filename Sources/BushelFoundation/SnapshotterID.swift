//
//  SnapshotterID.swift
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

/// An identifier for a Snapshotter.
public struct SnapshotterID:
  ExpressibleByStringInterpolation,
  Codable,
  Hashable,
  RawRepresentable,
  CustomStringConvertible,
  Sendable
{
  /// The type used for string literal initialization.
  public typealias StringLiteralType = String

  /// The identifier for the file version.
  public static let fileVersion: SnapshotterID = "fileVersion"

  /// The raw value of the identifier.
  public let rawValue: String

  /// The string representation of the identifier.
  public var description: String {
    self.rawValue
  }

  /// Initializes a `SnapshotterID` with the given raw value.
  ///
  /// - Parameter value: The raw value of the identifier.
  public init(rawValue value: String) {
    self.rawValue = value
  }

  /// Initializes a `SnapshotterID` with a string literal.
  ///
  /// - Parameter value: The string literal to use as the identifier.
  public init(stringLiteral value: String) {
    self.rawValue = value
  }

  /// Initializes a `SnapshotterID` from a decoder.
  ///
  /// - Parameter decoder: The decoder to use for initialization.
  /// - Throws: Any errors that may occur during decoding.
  public init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.rawValue = try container.decode(String.self)
  }

  /// Encodes the `SnapshotterID` to an encoder.
  ///
  /// - Parameter encoder: The encoder to use for encoding.
  /// - Throws: Any errors that may occur during encoding.
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
