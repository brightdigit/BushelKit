//
// InstallerImageMetadata.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public struct InstallerImageMetadata: Equatable {
  public let longName: String
  public let defaultName: String
  public let labelName: String
  public let operatingSystem: OperatingSystemVersion
  public let buildVersion: String?
  public let imageResourceName: String
  public let systemName: String
  public let vmSystemID: VMSystemID

  public var shortName: String {
    "\(labelName) (\(defaultName))"
  }

  public init(
    longName: String,
    defaultName: String,
    labelName: String,
    operatingSystem: OperatingSystemVersion,
    buildVersion: String?,
    imageResourceName: String,
    systemName: String,
    systemID: VMSystemID
  ) {
    self.longName = longName
    self.defaultName = defaultName
    self.labelName = labelName
    self.operatingSystem = operatingSystem
    self.buildVersion = buildVersion
    self.imageResourceName = imageResourceName
    self.systemName = systemName
    self.vmSystemID = systemID
  }
}
