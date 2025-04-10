//
//  ConfigurationRange.swift
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

/// A struct that represents a range of configuration values for CPU count and memory.
public struct ConfigurationRange: CustomStringConvertible, Sendable, Equatable {
  /// The default configuration range.
  public static let `default` = ConfigurationRange(
    cpuCount: 1...4,
    memory: (8 * 1_024 * 1_024 * 1_024)...(128 * 1_024 * 1_024 * 1_024)
  )

  /// The range of CPU count values.
  public let cpuCount: ClosedRange<Float>

  /// The range of memory values.
  public let memory: ClosedRange<Float>

  /// The description of the configuration range.
  public var description: String {
    "cpuCount: \(self.cpuCount); memory: \(self.memory)"
  }

  private var requiredMemoryFloat: Float? {
    guard self.memory.lowerBound < self.memory.upperBound else {
      return self.memory.upperBound
    }

    return nil
  }

  public var requiredMemory: Int64? {
    requiredMemoryFloat.map(Int64.init)
  }

  /// Initializes a new `ConfigurationRange` instance.
  ///
  /// - Parameters:
  ///   - cpuCount: The range of CPU count values.
  ///   - memory: The range of memory values.
  public init(cpuCount: ClosedRange<Float>, memory: ClosedRange<Float>) {
    self.cpuCount = cpuCount
    self.memory = memory
  }
}
