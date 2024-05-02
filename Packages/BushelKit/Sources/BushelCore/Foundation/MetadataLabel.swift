//
// MetadataLabel.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct MetadataLabel: Equatable, Sendable {
  public let operatingSystemLongName: String
  public let defaultName: String
  public let imageName: String
  public let systemName: String
  public let versionName: String

  @Sendable
  public init(
    operatingSystemLongName: String,
    defaultName: String,
    imageName: String,
    systemName: String,
    versionName: String
  ) {
    self.operatingSystemLongName = operatingSystemLongName
    self.defaultName = defaultName
    self.imageName = imageName
    self.systemName = systemName
    self.versionName = versionName
  }
}
