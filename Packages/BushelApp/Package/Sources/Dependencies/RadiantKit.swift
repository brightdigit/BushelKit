//
// RadiantKit.swift
// Copyright (c) 2024 BrightDigit.
//

struct RadiantKit: PackageDependency, TargetDependency {
  var dependency: Package.Dependency {
    .package(path: "../RadiantKit")
  }
}
