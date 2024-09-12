//
// DataThespian.swift
// Copyright (c) 2024 BrightDigit.
//

struct DataThespian: PackageDependency, TargetDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/brightdigit/DataThespian.git", from: "1.0.0-alpha.1")
  }
}
