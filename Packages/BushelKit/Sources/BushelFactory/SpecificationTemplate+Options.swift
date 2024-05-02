//
// SpecificationTemplate+Options.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelLocalization

public extension SpecificationTemplate {
  private enum Common {
    private static func handler(
      using: @escaping @Sendable (Int, Int) -> Int) -> @Sendable (any CalculationParameters) -> Int {
      { $0.value(using: using) }
    }

    static let min =
      Self.handler(using: {
        Swift.min($0, $1)
      })

    static let max =
      Self.handler(using: {
        Swift.max($0, $1)
      })
  }

  private enum Developer {
    @Sendable
    static func memoryWithin(_ parameters: any CalculationParameters) -> Int {
      parameters.indexFor(value: 8 * .bytesPerGB)
    }

    @Sendable
    static func cpuWithin(_ parameters: any CalculationParameters) -> Int {
      let valueRange = parameters.valueRange.clamped(to: 2 ... parameters.valueRange.upperBound - 2)
      let value = valueRange.clamped(to: 2 ... 6).upperBound
      return parameters.indexFor(value: value)
    }
  }

  static let basic: SpecificationTemplate = .init(
    nameID: .machineDialogSpecTemplateNameBasic,
    systemImageName: "apple.terminal",
    idealStorage: 64 * .bytesPerGB,
    memoryWithin: Common.min,
    cpuWithin: Common.min
  )

  static let developer: SpecificationTemplate = .init(
    nameID: .machineDialogSpecTemplateNameDeveloper,
    systemImageName: "hammer.fill",
    idealStorage: 128 * .bytesPerGB,
    memoryWithin: Developer.memoryWithin,
    cpuWithin: Developer.cpuWithin(_:)
  )

  static let maximum: SpecificationTemplate = .init(
    nameID: .machineDialogSpecTemplateNameMaximum,
    systemImageName: "bolt.fill",
    idealStorage: 512 * .bytesPerGB,
    memoryWithin: Common.max,
    cpuWithin: Common.max
  )

  static let options: [SpecificationTemplate] = [
    .basic,
    .developer,
    .maximum
  ]
}
