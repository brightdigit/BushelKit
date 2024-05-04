//
// IPSWDownloads.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct IPSWDownloads: PackageDependency, TargetDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/brightdigit/IPSWDownloads.git", from: "1.0.0-beta.4")
  }
}
