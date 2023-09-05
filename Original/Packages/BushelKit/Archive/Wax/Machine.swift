//
// Machine.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelVirtualization
import Foundation

public extension Machine {
  static let preview: Machine = .init(
    operatingSystem:
    .init(
      type: .macOS,
      version: .init(majorVersion: 13, minorVersion: 0, patchVersion: 1),
      buildVersion: "22A379"
    ),
    snapshots: [
      .preview(timeIntervalSinceNow: 60 * 60 * -1.0),
      .preview(timeIntervalSinceNow: 60 * 60 * -2.0),
      .preview(timeIntervalSinceNow: 60 * 60 * -3.0),
      .preview(timeIntervalSinceNow: 60 * 60 * -4.0)
    ],
    specification: .preview
  )
}
