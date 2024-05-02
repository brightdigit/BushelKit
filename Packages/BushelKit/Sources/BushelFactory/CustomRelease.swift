//
// CustomRelease.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore

public struct CustomRelease: InstallerRelease {
  public static let instance = CustomRelease()
  public var versionName: String {
    "custom"
  }

  public var releaseName: String {
    "custom"
  }

  public var imageName: String {
    "custom"
  }

  public var majorVersion: Int {
    -1
  }

  public var id: Int {
    -1
  }

  private init() {}
}

extension InstallerRelease {
  var isCustom: Bool {
    self is CustomRelease
  }
}
