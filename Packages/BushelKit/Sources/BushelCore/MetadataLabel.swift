//
// MetadataLabel.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct MetadataLabel {
  public let operatingSystemLongName: String
  public let defaultName: String
  public let imageName: String
  public let systemName: String

  public init(operatingSystemLongName: String, defaultName: String, imageName: String, systemName: String) {
    self.operatingSystemLongName = operatingSystemLongName
    self.defaultName = defaultName
    self.imageName = imageName
    self.systemName = systemName
  }
}
