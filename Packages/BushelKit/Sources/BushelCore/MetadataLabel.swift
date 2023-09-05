//
// MetadataLabel.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct MetadataLabel {
  public init(operatingSystemLongName: String, defaultName: String, imageName: String) {
    self.operatingSystemLongName = operatingSystemLongName
    self.defaultName = defaultName
    self.imageName = imageName
  }

  public let operatingSystemLongName: String
  public let defaultName: String
  public let imageName: String
}
