//
// Firmware.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation
import IPSWDownloads

extension Firmware: OperatingSystemInstalled {
  private struct InvalidURLError: Error {
    let string: String
  }

  public var buildVersion: String? {
    self.buildid
  }

  public var operatingSystemVersion: OperatingSystemVersion {
    self.version
  }
}
