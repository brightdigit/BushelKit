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

public enum Specifications {
  public enum Handlers {
    public static let min =
      Specifications.handler(using: {
        Swift.min($0, $1)
      })

    public static let max =
      Specifications.handler(using: {
        Swift.max($0, $1)
      })
  }

  public enum Developer {
    @Sendable
    public static func memoryWithin(_ parameters: any CalculationParameters) -> Int {
      parameters.indexFor(value: 8 * .bytesPerGB)
    }

    @Sendable
    public static func cpuWithin(_ parameters: any CalculationParameters) -> Int {
      let valueRange = parameters.valueRange.clamped(to: 2...parameters.valueRange.upperBound - 2)
      let value = valueRange.clamped(to: 2...6).upperBound
      return parameters.indexFor(value: value)
    }
  }

  internal static let fullMemoryRange = 1...11
  internal static let fullStorageRange = 36...42
  public static let fullStorageBoundsRange: ClosedRange<Float> = .init(intRange: fullStorageRange)

  private static func handler(
    using: @escaping @Sendable (Int, Int) -> Int
  ) -> @Sendable (any CalculationParameters) -> Int {
    { $0.value(using: using) }
  }
}
