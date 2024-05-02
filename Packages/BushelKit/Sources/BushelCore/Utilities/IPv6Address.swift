//
// IPv6Address.swift
// Copyright (c) 2024 BrightDigit.
//

// swiftlint:disable all
import Foundation
public typealias IPv6Address = UInt128

@available(*, unavailable, message: "Not Ready for Use.")
extension IPv6Address {
  func toIPv6AddressFormat() -> String {
    // Convert high and low parts to string representation
    // This is a simplified example
    // You would need proper formatting here
    String(format: "%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x",
           (value.upperBits >> 48) & 0xFFFF,
           (value.upperBits >> 32) & 0xFFFF,
           (value.upperBits >> 16) & 0xFFFF,
           value.upperBits & 0xFFFF,
           (value.lowerBits >> 48) & 0xFFFF,
           (value.lowerBits >> 32) & 0xFFFF,
           (value.lowerBits >> 16) & 0xFFFF,
           value.lowerBits & 0xFFFF)
  }

  init(fromIPv6Address string: String) {
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
