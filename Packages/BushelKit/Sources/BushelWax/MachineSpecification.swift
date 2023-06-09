//
// MachineSpecification.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelVirtualization
import Foundation

public extension MachineSpecification {
  static let preview: MachineSpecification = .init(
    cpuCount: 19,
    memorySize: 32 * 1024 * 1024 * 1024,
    storageDevices: [
      .init(id: .init(), label: "preview OS", size: UInt64(256 * 1024 * 1024 * 1024))
    ],
    networkConfigurations: [
      .init(attachment: .nat)
    ],
    graphicsConfigurations: [
      .init(displays: [
        .init(widthInPixels: 1920, heightInPixels: 1080, pixelsPerInch: 80)
      ])
    ]
  )
}
