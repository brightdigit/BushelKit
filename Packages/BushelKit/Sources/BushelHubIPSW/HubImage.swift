//
// HubImage.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelHub
import BushelMacOSCore
import Foundation
import IPSWDownloads

public extension HubImage {
  init(firmware: Firmware) throws {
    try self.init(
      title: MacOSVirtualization.operatingSystemShortName(for: firmware),
      metadata: .init(firmware: firmware),
      url: firmware.url
    )
  }
}
