//
// MacOSRelease.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public struct MacOSRelease: InstallerRelease {
  public let majorVersion: Int
  public let versionName: String
  public let releaseName: String
  public let imageName: String
  public var id: Int {
    majorVersion
  }

  public init?(majorVersion: Int) {
    guard let releaseName = OperatingSystemVersion.macOSReleaseName(majorVersion: majorVersion) else {
      assertionFailure("Missing Metadata for macOS \(majorVersion).")
      return nil
    }

    guard let imageName = MacOSVirtualization.imageName(forMajorVersion: majorVersion) else {
      assertionFailure("Missing Image for macOS \(majorVersion).")
      return nil
    }

    let versionName = "\(MacOSVirtualization.shortName) \(majorVersion)"

    self.init(
      majorVersion: majorVersion,
      releaseName: releaseName,
      versionName: versionName,
      imageName: imageName
    )
  }

  private init(majorVersion: Int, releaseName: String, versionName: String, imageName: String) {
    self.majorVersion = majorVersion
    self.releaseName = releaseName
    self.versionName = versionName
    self.imageName = imageName
  }
}
