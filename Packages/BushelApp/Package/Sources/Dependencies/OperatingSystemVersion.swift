//
// OperatingSystemVersion.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct OperatingSystemVersion: PackageDependency, TargetDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/brightdigit/OperatingSystemVersion.git", from: "1.0.0-beta.1")
  }
}
