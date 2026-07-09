//
//  SystemConfiguration.swift
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

/// A snapshot of the host system's hardware and operating system characteristics.
public struct SystemConfiguration: Sendable, Codable, Equatable {
  /// The operating system version, expressed as a string.
  public let operatingSystemVersionString: String
  /// The total physical memory available on the system, in bytes.
  public let physicalMemory: Int
  /// The total number of processors on the system.
  public let processorCount: Int
  /// The number of currently active processors on the system.
  public let activeProcessorCount: Int

  /// Creates a new system configuration.
  ///
  /// - Parameters:
  ///   - operatingSystemVersionString: The operating system version string.
  ///   - physicalMemory: The total physical memory in bytes.
  ///   - processorCount: The total number of processors.
  ///   - activeProcessorCount: The number of active processors.
  public init(
    operatingSystemVersionString: String,
    physicalMemory: Int,
    processorCount: Int,
    activeProcessorCount: Int
  ) {
    self.operatingSystemVersionString = operatingSystemVersionString
    self.physicalMemory = physicalMemory
    self.processorCount = processorCount
    self.activeProcessorCount = activeProcessorCount
  }
}

extension SystemConfiguration {
  /// Creates a new system configuration using an unsigned physical memory value.
  ///
  /// - Parameters:
  ///   - operatingSystemVersionString: The operating system version string.
  ///   - physicalMemory: The total physical memory in bytes.
  ///   - processorCount: The total number of processors.
  ///   - activeProcessorCount: The number of active processors.
  public init(
    operatingSystemVersionString: String,
    physicalMemory: UInt64,
    processorCount: Int,
    activeProcessorCount: Int
  ) {
    self.init(
      operatingSystemVersionString: operatingSystemVersionString,
      physicalMemory: Int(physicalMemory),
      processorCount: processorCount,
      activeProcessorCount: activeProcessorCount
    )
  }
}
