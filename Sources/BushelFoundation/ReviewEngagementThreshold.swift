//
//  ReviewEngagementThreshold.swift
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

public import BushelUtilities
public import Foundation

/// The threshold of user engagement actions required before requesting an app review.
public struct ReviewEngagementThreshold:
  RawRepresentable,
  EnvironmentValue,
  ExpressibleByIntegerLiteral,
  Sendable,
  Codable,
  Equatable
{
  public typealias RawValue = Int

  /// The default threshold value (10 interactions).
  public static let `default`: ReviewEngagementThreshold = 10

  /// The underlying integer value.
  public let rawValue: Int

  /// Returns the string representation for environment variable storage.
  public var environmentStringValue: String {
    "\(rawValue)"
  }

  /// Creates a threshold from a raw integer value.
  /// - Parameter rawValue: The threshold count. Must be non-negative.
  public init(rawValue: Int) {
    assert(rawValue >= 0, "ReviewEngagementThreshold must be non-negative")
    self.rawValue = rawValue
  }

  /// Creates a threshold from an environment variable string.
  /// - Parameter environmentStringValue: The string value from the environment.
  /// - Returns: A threshold instance, or nil if the string is not a valid integer or is negative.
  public init?(environmentStringValue: String) {
    guard let value = Int(environmentStringValue) else {
      return nil
    }
    assert(value >= 0, "ReviewEngagementThreshold must be non-negative")
    self.rawValue = value
  }

  /// Creates a threshold from an integer literal.
  /// - Parameter value: The literal integer value. Must be non-negative.
  public init(integerLiteral value: IntegerLiteralType) {
    assert(value >= 0, "ReviewEngagementThreshold must be non-negative")
    self.rawValue = value
  }
}
