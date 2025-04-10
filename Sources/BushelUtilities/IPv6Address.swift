//
//  IPv6Address.swift
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

// swiftlint:disable all

/// A type alias for an IPv6 address represented as a `UInt128`.
public typealias IPv6Address = UInt128

@available(*, unavailable, message: "Not Ready for Use.")
extension IPv6Address {
  /// Converts the `IPv6Address` to a string representation in the standard IPv6 address format.
  ///
  /// - Returns: A string representation of the IPv6 address.
  public func toIPv6AddressFormat() -> String {
    // Convert high and low parts to string representation
    // This is a simplified example
    // You would need proper formatting here
    String(
      format: "%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x",
      (value.upperBits >> 48) & 0xFFFF,
      (value.upperBits >> 32) & 0xFFFF,
      (value.upperBits >> 16) & 0xFFFF,
      value.upperBits & 0xFFFF,
      (value.lowerBits >> 48) & 0xFFFF,
      (value.lowerBits >> 32) & 0xFFFF,
      (value.lowerBits >> 16) & 0xFFFF,
      value.lowerBits & 0xFFFF
    )
  }

  /// Initializes an `IPv6Address` from a string representation in the standard IPv6 address format.
  ///
  /// - Parameter string: The string representation of the IPv6 address.
  public init(fromIPv6Address string: String) {
    // Parse string and convert to high and low parts
    // This is a simplified example
    // You would need proper parsing and error handling here
    let parts = string.split(separator: ":")
    var high: UInt64 = 0
    var low: UInt64 = 0

    for (index, part) in parts.enumerated() {
      if index < 4 {
        high <<= 16
        high |= UInt64(part, radix: 16)!
      } else {
        low <<= 16
        low |= UInt64(part, radix: 16)!
      }
    }

    self.init(upperBits: high, lowerBits: low)
  }
}
// swiftlint:enable all
