//
// Specifications.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelFactory
import BushelLocalization
import Foundation

extension Specifications {
  internal enum Options {
    internal static let basic: SpecificationTemplate<LocalizedStringID> = .init(
      nameID: .machineDialogSpecTemplateNameBasic,
      systemImageName: "apple.terminal",
      idealStorage: 64 * .bytesPerGB,
      memoryWithin: Specifications.Handlers.min,
      cpuWithin: Specifications.Handlers.min
    )

    internal static let developer: SpecificationTemplate<LocalizedStringID> = .init(
      nameID: .machineDialogSpecTemplateNameDeveloper,
      systemImageName: "hammer.fill",
      idealStorage: 128 * .bytesPerGB,
      memoryWithin: Developer.memoryWithin,
      cpuWithin: Developer.cpuWithin(_:)
    )

    internal static let maximum: SpecificationTemplate<LocalizedStringID> = .init(
      nameID: .machineDialogSpecTemplateNameMaximum,
      systemImageName: "bolt.fill",
      idealStorage: 512 * .bytesPerGB,
      memoryWithin: Specifications.Handlers.max,
      cpuWithin: Specifications.Handlers.max
    )

    internal static let all: [SpecificationTemplate<LocalizedStringID>] = [
      Self.basic,
      Self.developer,
      Self.maximum
    ]
  }
}
