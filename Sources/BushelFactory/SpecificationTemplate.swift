//
//  SpecificationTemplate.swift
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

/// A named template that computes recommended CPU, memory, and storage for a machine.
public struct SpecificationTemplate<Name: Hashable & Sendable>: Identifiable, Sendable, Equatable {
  /// The identifier naming this template.
  public let nameID: Name
  /// The recommended storage size, in gigabytes.
  public let idealStorage: Int
  /// The name of the system image representing this template.
  public let systemImageName: String

  internal let memoryWithin: @Sendable (any CalculationParameters) -> Int
  internal let cpuWithin: @Sendable (any CalculationParameters) -> Int

  /// The stable identifier for this template.
  public var id: Name {
    nameID
  }

  /// Creates a specification template with the given identity and value-calculation closures.
  /// - Parameters:
  ///   - nameID: The identifier naming the template.
  ///   - systemImageName: The name of the system image representing the template.
  ///   - idealStorage: The recommended storage size, in gigabytes.
  ///   - memoryWithin: A closure computing the recommended memory index for a given range.
  ///   - cpuWithin: A closure computing the recommended CPU index for a given range.
  public init(
    nameID: Name,
    systemImageName: String,
    idealStorage: Int,
    memoryWithin: @escaping @Sendable (any CalculationParameters) -> Int,
    cpuWithin: @escaping @Sendable (any CalculationParameters) -> Int
  ) {
    self.nameID = nameID
    self.systemImageName = systemImageName
    self.memoryWithin = memoryWithin
    self.cpuWithin = cpuWithin
    self.idealStorage = idealStorage
  }

  /// Compares two templates by their identifiers.
  /// - Parameters:
  ///   - lhs: The first template to compare.
  ///   - rhs: The second template to compare.
  /// - Returns: `true` if the templates share the same identifier.
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }

  internal func memoryIndex(
    within indexRange: ClosedRange<Float>,
    valuesWith valueRange: ClosedRange<Float>,
    indexForValue: @escaping @Sendable (Int) -> Int
  ) -> Float {
    let parameters = SpecificationCalculationParameters(
      indexRange: indexRange,
      valueRange: valueRange,
      indexForValue: indexForValue
    )
    return memoryIndex(for: parameters)
  }

  internal func cpuIndex(
    within indexRange: ClosedRange<Float>,
    valuesWith valueRange: ClosedRange<Float>,
    indexForValue: @escaping @Sendable (Int) -> Int
  ) -> Float {
    let parameters = SpecificationCalculationParameters(
      indexRange: indexRange,
      valueRange: valueRange,
      indexForValue: indexForValue
    )
    return cpuIndex(for: parameters)
  }

  private func memoryIndex(for parameters: any CalculationParameters) -> Float {
    Float(self.memoryWithin(parameters))
  }

  private func cpuIndex(for parameters: any CalculationParameters) -> Float {
    Float(self.cpuWithin(parameters))
  }
}
