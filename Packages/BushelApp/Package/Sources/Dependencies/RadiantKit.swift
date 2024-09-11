//
// RadiantKit.swift
// Copyright (c) 2024 BrightDigit.
//

struct RadiantKit: PackageDependency, TargetDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/brightdigit/RadiantKit.git", from: "1.0.0-alpha.1")
  }
}
