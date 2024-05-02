//
// InstallerImageMetadata.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine
import Foundation

public extension InstallerImageMetadata {
  init(operatingSystem: OperatingSystemVersion) {
    self.init(
      longName: .randomLowerCaseAlphaNumberic(),
      defaultName: .randomLowerCaseAlphaNumberic(),
      labelName: .randomLowerCaseAlphaNumberic(),
      operatingSystem: operatingSystem,
      buildVersion: .randomLowerCaseAlphaNumberic(),
      imageResourceName: .randomLowerCaseAlphaNumberic(),
      systemName: .randomLowerCaseAlphaNumberic(),
      systemID: "testing"
    )
  }
}
