//
// MockInstallerRelease.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore

struct MockInstallerRelease: InstallerRelease {
  let versionName: String

  let releaseName: String

  let imageName: String

  let majorVersion: Int

  var id: Int {
    majorVersion
  }
}
