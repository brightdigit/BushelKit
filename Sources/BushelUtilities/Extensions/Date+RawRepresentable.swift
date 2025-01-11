//
//  Date+RawRepresentable.swift
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

extension Date: @retroactive RawRepresentable {
  /// The raw value type for the Date extension.
  public typealias RawValue = Int

  /// The number of milliseconds in one second.
  private static let millisecondsInSeconds: TimeInterval = 1_000

  /// The raw value representation of the Date.
  ///
  /// - Returns: The raw value of the Date as an Int.
  public var rawValue: Int {
    Int(self.timeIntervalSince1970 * Self.millisecondsInSeconds)
  }

  /// Initializes a Date from a raw value.
  ///
  /// - Parameter rawValue: The raw value to initialize the Date from.
  /// - Returns: An optional Date instance initialized from the raw value,
  /// or nil if the raw value is invalid.
  public init?(rawValue: Int) {
    self.init(timeIntervalSince1970: TimeInterval(rawValue) / Self.millisecondsInSeconds)
  }
}
