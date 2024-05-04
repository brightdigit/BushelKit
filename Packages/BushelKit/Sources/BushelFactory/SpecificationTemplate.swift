//
// SpecificationTemplate.swift
// Copyright (c) 2024 BrightDigit.
//

// import BushelLocalization

public struct SpecificationTemplate<Name: Hashable>: Identifiable, Sendable, Equatable {
  public let nameID: Name
  public let idealStorage: Int
  public let systemImageName: String

  let memoryWithin: @Sendable (any CalculationParameters) -> Int
  let cpuWithin: @Sendable (any CalculationParameters) -> Int

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
