//
//  Specifications.swift
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

/// A namespace of predefined specification handlers and value ranges used to size virtual machines.
public enum Specifications {
  /// Handlers that pick a specification index from the bounds of a calculation range.
  public enum Handlers {
    /// A handler that selects the lower bound of the available range.
    public static let min =
      Specifications.handler(using: {
        Swift.min($0, $1)
      })

    /// A handler that selects the upper bound of the available range.
    public static let max =
      Specifications.handler(using: {
        Swift.max($0, $1)
      })
  }

  /// Specification handlers tuned for developer workloads.
  public enum Developer {
    /// Returns the memory index corresponding to a recommended 8 GB allocation.
    /// - Parameter parameters: The calculation parameters describing the available memory range.
    /// - Returns: The index for the recommended memory value.
    @Sendable
    public static func memoryWithin(_ parameters: any CalculationParameters) -> Int {
      parameters.indexFor(value: 8 * .bytesPerGB)
    }

    /// Returns the CPU index corresponding to a recommended core count within the available range.
    /// - Parameter parameters: The calculation parameters describing the available CPU range.
    /// - Returns: The index for the recommended CPU value.
    @Sendable
    public static func cpuWithin(_ parameters: any CalculationParameters) -> Int {
      let valueRange = parameters.valueRange.clamped(to: 2...parameters.valueRange.upperBound - 2)
      let value = valueRange.clamped(to: 2...6).upperBound
      return parameters.indexFor(value: value)
    }
  }

  internal static let fullMemoryRange = 1...11
  internal static let fullStorageRange = 36...42
  /// The full range of storage index bounds expressed as floating-point values.
  public static let fullStorageBoundsRange: ClosedRange<Float> = .init(intRange: fullStorageRange)

  private static func handler(
    using: @escaping @Sendable (Int, Int) -> Int
  ) -> @Sendable (any CalculationParameters) -> Int {
    { $0.value(using: using) }
  }
}
