//
// ImageMetadata.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelVirtualization
import Foundation

public extension ImageMetadata {
//  var defaultName: String {
//    // swiftlint:disable:next force_unwrapping
//    AnyImageManagers.imageManager(forSystem: vmSystem)?.defaultName(for: self) ?? "preview"
//  }

  var localizedVersionString: String {
    [
      Bundle.module.localizedString(forKey: "version", value: nil, table: nil),
      operatingSystemVersion.description,
      "(\(buildVersion.description))"
    ].joined(separator: " ")
  }
}
