//
// Machine+Previews.swift
// Copyright (c) 2022 BrightDigit.
//

import BushelMachine
import Foundation

extension MachineSpecification {
  static let preview: MachineSpecification = .init(
    cpuCount: 19,
    memorySize: 32 * 1024 * 1024 * 1024,
    storageDevices: [
      .init(id: .init(), size: UInt64(256 * 1024 * 1024 * 1024))
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

extension Machine {
  static let preview: Machine = .init(
    operatingSystem:
    .init(
      type: .macOS,
      version: .init(majorVersion: 13, minorVersion: 0, patchVersion: 1),
      buildVersion: "22A379"
    ),
    snapshots: [
      MachineSnapshot(id: Data.random(), url: .init("https://google.com"), isDiscardable: false, date: Date(timeIntervalSinceNow: 60 * 60 * -1)),
      MachineSnapshot(id: Data.random(), url: .init("https://google.com"), isDiscardable: false, date: Date(timeIntervalSinceNow: 60 * 60 * -2)),
      MachineSnapshot(id: Data.random(), url: .init("https://google.com"), isDiscardable: false, date: Date(timeIntervalSinceNow: 60 * 60 * -3)),
      MachineSnapshot(id: Data.random(), url: .init("https://google.com"), isDiscardable: false, date: Date(timeIntervalSinceNow: 60 * 60 * -48))
    ],
    specification: .preview
  )
}
