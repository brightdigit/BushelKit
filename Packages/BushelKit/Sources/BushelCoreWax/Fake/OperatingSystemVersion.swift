//
// OperatingSystemVersion.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

package extension OperatingSystemVersion {
  package static func random() -> OperatingSystemVersion {
    .init(
      majorVersion: .random(in: 12 ... 15),
      minorVersion: .random(in: 0 ... 6),
      patchVersion: .random(in: 0 ... 7)
    )
  }
}
