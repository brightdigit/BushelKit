//
// FelinePine.swift
// Copyright (c) 2024 BrightDigit.
//

import PackageDescription

struct FelinePine: PackageDependency, TargetDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/brightdigit/FelinePine.git", from: "1.0.0-beta.2")
  }
}
