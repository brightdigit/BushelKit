//
// LibraryImageFile.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelLibrary
import Foundation

public extension LibraryImageFile {
  static let libraryImageSample: Self = .init(
    // swiftlint:disable:next force_unwrapping
    id: .init(uuidString: "C2D7C339-D60D-4E17-A665-3BFA53389DDD")!,
    metadata: .macOS_13_6_0_22G120,
    name: "macOS Ventura 13.6.0"
  )

  // swiftlint:disable:next identifier_name
  static let monterey_12_6_0: Self = .init(
    // swiftlint:disable:next force_unwrapping
    id: .init(uuidString: "D8ED8AF1-9AC7-49D4-A29D-E81F67B5F489")!,
    metadata: .macOS_12_6_0_21G115,
    name: "macOS Monterey 12.6.0"
  )

  // swiftlint:disable:next identifier_name
  static let ventura_13_6_0: Self = .init(
    // swiftlint:disable:next force_unwrapping
    id: .init(uuidString: "C2983C2F-D69A-47CD-8656-11314EAFE52F")!,
    metadata: .macOS_13_6_0_22G120,
    name: "macOS Ventura 13.6.0"
  )

  // swiftlint:disable:next identifier_name
  static let sonoma_13_6_0: Self = .init(
    // swiftlint:disable:next force_unwrapping
    id: .init(uuidString: "9FD629E1-CC0C-444F-9836-513B5444EA44")!,
    metadata: .macOS_14_0_0_23A344,
    name: "macOS Sonoma 14.0.0"
  )
}
