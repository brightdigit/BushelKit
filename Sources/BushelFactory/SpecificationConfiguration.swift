//
//  SpecificationConfiguration.swift
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

public import BushelFoundation
internal import BushelMachine

public struct SpecificationConfiguration<Name: Hashable & Sendable>: Equatable, Sendable {
  public let configurationRange: ConfigurationRange
  public let memoryIndexRange: ClosedRange<Float>
  private var updatingValues = false
  public var isValid: Bool {
    guard self.configurationRange.cpuCount.contains(self.cpuCount) else {
      return false
    }
    if let requiredMemory = configurationRange.requiredMemory {
      guard self.memory == requiredMemory else {
        return false
      }
    } else {
      guard self.configurationRange.memory.contains(Float(self.memory)) else {
        return false
      }
    }
    return storage > 0
  }

  public var template: SpecificationTemplate<Name>? {
    didSet {
      if let template {
        self.updatingValues = true
        self.memoryIndex = template.memoryIndex(
          within: self.memoryIndexRange,
          valuesWith: self.configurationRange.memory,
          indexForValue: {
            Self.binarySearch(
              for: $0,
              using: { Self.memoryValue(forIndex: $0) },
              within: Specifications.fullMemoryRange
            )
          }
        )
        self.cpuCount = template.cpuIndex(
          within: self.configurationRange.cpuCount,
          valuesWith: self.configurationRange.cpuCount,
          indexForValue: {
            $0
          }
        )

        self.storageIndex = Self.binarySearch(
          for: .init(template.idealStorage),
          using: { Self.storageValue(forIndex: $0) },
          within: Specifications.fullStorageRange
        )
        self.updatingValues = false
      }
    }
  }

  public var cpuCount: Float = 1 {
    didSet {
      if !updatingValues {
        self.template = .none
      }
    }
  }

  public private(set) var memory: Int64
  public var memoryIndex: Float = 1 {
    willSet {
      if let requiredMemory = configurationRange.requiredMemory {
        self.memory = requiredMemory
      }
      self.memory = Self.memoryValue(forIndex: newValue)
      if !updatingValues {
        self.template = nil
      }
    }
  }

  public private(set) var storage: Int64
  public var storageIndex: Float = 36 {
    willSet {
      self.storage = Self.storageValue(forIndex: newValue)
      if !updatingValues {
        self.template = nil
      }
    }
  }

  public init(
    range: ConfigurationRange = .default,
    template: SpecificationTemplate<Name>? = nil,
    cpuCount: Float = 1,
    memoryIndex: Float = 1,
    storageIndex: Float = 36
  ) {
    self.configurationRange = range
    self.template = template
    self.cpuCount = cpuCount
    self.memory = range.requiredMemory ?? Self.memoryValue(forIndex: memoryIndex)
    self.memoryIndex = memoryIndex
    self.storage = Self.storageValue(forIndex: storageIndex)
    self.storageIndex = storageIndex
    let memoryIndexRangeUpper = Self.binarySearch(
      for: configurationRange.memory.upperBound,
      using: { Self.memoryValue(forIndex: $0) },
      within: Specifications.fullMemoryRange,
      lower: 1
    )
    self.memoryIndexRange = .init(
      uncheckedBounds: (
        lower: 1,
        upper: memoryIndexRangeUpper
      )
    )
  }
  private static func binarySearch(
    for value: Float,
    using: @escaping @Sendable (Int) -> Int,
    within range: ClosedRange<Int>,
    lower: Float
  ) -> Float {
    max(self.binarySearch(for: value, using: using, within: range), lower)
  }

  private static func binarySearch(
    for value: Int,
    using: @escaping @Sendable (Int) -> Int,
    within range: ClosedRange<Int>
  ) -> Int {
    self.binarySearch(for: Int(value), using: using, low: range.lowerBound, high: range.upperBound)
  }

  private static func binarySearch(
    for value: Float,
    using: @escaping @Sendable (Int) -> Int,
    within range: ClosedRange<Int>
  ) -> Float {
    Float(self.binarySearch(for: Int(value), using: using, within: range))
  }

  private static func binarySearch(
    for value: Int,
    using: @escaping @Sendable (Int) -> Int,
    low: Int,
    high: Int
  ) -> Int {
    guard low <= high else {
      return low - 1
    }

    let mid = (low + high) / 2
    let calculatedMemoryValue = using(mid)

    if calculatedMemoryValue == value {
      return mid
    } else if calculatedMemoryValue < value {
      return binarySearch(for: value, using: using, low: mid + 1, high: high)
    } else {
      return binarySearch(for: value, using: using, low: low, high: mid - 1)
    }
  }

  private static func storageValue(forIndex index: Int) -> Int {
    Int(self.storageValue(forIndex: Float(index)))
  }

  private static func storageValue(forIndex index: Float) -> Int64 {
    Int64(1 << Int(index))
  }

  private static func memoryValue(forIndex index: Float) -> Int64 {
    Int64(memoryValue(forIndex: Int(index)))
  }

  private static func memoryValue(forIndex index: Int) -> Int {
    guard index > 0 else {
      return 0
    }

    let factor = ((index - 1) / 4)
    let increment = (1 << factor) * 8 * .bytesPerGB
    return memoryValue(forIndex: index - 1) + increment
  }
}
