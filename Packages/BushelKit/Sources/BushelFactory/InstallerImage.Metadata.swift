//
// InstallerImage.Metadata.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelLibrary
import BushelMachine
import Foundation

extension InstallerImage.Metadata {
  init(
    labelName: String,
    imageMetadata: ImageMetadata,
    _ labelProvider: @escaping MetadataLabelProvider
  ) {
    let label = labelProvider(imageMetadata.vmSystemID, imageMetadata)
    self.init(
      longName: label.operatingSystemLongName,
      defaultName: label.defaultName,
      labelName: labelName,
      operatingSystem: imageMetadata.operatingSystemVersion,
      buildVersion: imageMetadata.buildVersion,
      imageResourceName: label.imageName,
      systemName: label.systemName,
      systemID: imageMetadata.vmSystemID
    )
  }
}
