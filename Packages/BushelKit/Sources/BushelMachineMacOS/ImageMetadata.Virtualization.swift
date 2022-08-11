//
// ImageMetadata.Virtualization.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/8/22.
//

import BushelMachine
import Virtualization

extension ImageMetadata {
  init(contentLength: Int, lastModified: Date, vzRestoreImage: VZMacOSRestoreImage) {
    self.init(isImageSupported: vzRestoreImage.isImageSupported, buildVersion: vzRestoreImage.buildVersion, operatingSystemVersion: vzRestoreImage.operatingSystemVersion, contentLength: contentLength, lastModified: lastModified, fileExtension: "ipsw", vmSystem: .macOS)
  }
}
