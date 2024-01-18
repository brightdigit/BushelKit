//
// ImageMetadata.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import IPSWDownloads

public extension ImageMetadata {
  init(firmware: Firmware) throws {
    self.init(
      isImageSupported: true,
      buildVersion: firmware.buildid,
      operatingSystemVersion: firmware.version,
      contentLength: Int(firmware.filesize),
      lastModified: firmware.releasedate,
      fileExtension: FileType.ipswFileExtension,
      vmSystemID: .macOS
    )
  }
}
