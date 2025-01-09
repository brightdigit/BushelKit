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

public struct SpecificationTemplate<Name: Hashable & Sendable>: Identifiable, Sendable, Equatable {
  public let nameID: Name
  public let idealStorage: Int
  public let systemImageName: String

  internal let memoryWithin: @Sendable (any CalculationParameters) -> Int
  internal let cpuWithin: @Sendable (any CalculationParameters) -> Int

  public var id: Name {
    nameID
  }

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
