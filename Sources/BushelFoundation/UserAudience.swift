//
//  UserAudience.swift
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

/// Represents a set of user audience types for a particular purpose.
public struct UserAudience: OptionSet, Sendable {
  /// The raw value of the user audience.
  public typealias RawValue = Int

  /// The Pro subscriber audience.
  public static let proSubscriber: UserAudience = .init(rawValue: 1)

  /// The TestFlight beta audience.
  public static let testFlightBeta: UserAudience = .init(rawValue: 2)

  /// The any audience, which includes all possible user audiences.
  public static let any: UserAudience = .init(rawValue: .max)

  /// The default audience, which includes the TestFlight beta and Pro subscriber audiences.
  public static let `default`: UserAudience = [.testFlightBeta, proSubscriber]

  /// The empty audience, which includes no user audiences.
  public static let none: UserAudience = []

  /// The available user audiences.
  public static var availableValues: UserAudience {
    .default
  }

  /// The raw value of the user audience.
  public var rawValue: Int

  /// Initializes a new `UserAudience` instance with the given raw value.
  ///
  /// - Parameter rawValue: The raw value of the user audience.
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

  // Commented-out function:
  // /// Checks if the given user audience is included in the current user audience.
  // ///
  // /// - Parameter value: The user audience to check.
  // /// - Returns: `true` if the given user audience is included, `false` otherwise.
  // public static func includes(_ value: UserAudience) -> Bool {
  //     guard value.rawValue > 0 else {
  //         return false
  //     }
  //     let value: Bool = .random()
  //     return value
  // }
}
