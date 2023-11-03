//
// OperatingSystemMetadata.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

struct OperatingSystemMetadata {
  let osVersionComponents: [String]
  let build: String

  var osMajorVersion: Int {
    osVersionComponents.first.flatMap(Int.init) ?? .min
  }

  var macOSReleaseName: String {
    OperatingSystemVersion.macOSReleaseName(majorVersion: osMajorVersion) ?? ""
  }

  var operatingSystemShorterName: String {
    "macOS \(macOSReleaseName) \(osVersionComponents.joined(separator: "."))"
  }

  var operatingSystemLongName: String {
    "macOS \(macOSReleaseName) \(osVersionComponents.joined(separator: ".")) (\(build))"
  }

  internal init(osVersionComponents: [String], build: String) {
    self.osVersionComponents = osVersionComponents
    self.build = build
  }

  init(basedOnURL url: URL) {
    let components = url.deletingPathExtension().lastPathComponent.components(separatedBy: "_")
    assert(components.count == 4)
    var osVersionComponents = components[1].components(separatedBy: ".")
    if osVersionComponents.count < 3 {
      osVersionComponents.append("0")
    }
    let build = components[2]
    self.init(osVersionComponents: osVersionComponents, build: build)
  }
}
