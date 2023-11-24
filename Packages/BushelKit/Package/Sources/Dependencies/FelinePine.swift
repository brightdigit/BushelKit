//
// FelinePine.swift
// Copyright (c) 2023 BrightDigit.
//

import PackageDescription

struct FelinePine: PackageDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/brightdigit/FelinePine.git", from: "1.0.0-beta.1")
  }
}
