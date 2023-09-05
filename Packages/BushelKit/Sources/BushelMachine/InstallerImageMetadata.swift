//
// InstallerImageMetadata.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public struct InstallerImageMetadata {
  public init(longName: String, defaultName: String, labelName: String, operatingSystem: OperatingSystemVersion, buildVersion: String, systemID: VMSystemID) {
    self.longName = longName
    self.defaultName = defaultName
    self.labelName = labelName
    self.operatingSystem = operatingSystem
    self.buildVersion = buildVersion
    self.systemID = systemID
  }

  public let longName: String
  public let defaultName: String
  public let labelName: String
  public let operatingSystem: OperatingSystemVersion
  public let buildVersion: String
  public let systemID: VMSystemID

  public var shortName: String {
    "\(labelName) (\(defaultName))"
  }
}
