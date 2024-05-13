//
// FeatherQuill.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct FeatherQuill: PackageDependency, TargetDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/brightdigit/FeatherQuill.git", from: "1.0.0-alpha.2")
  }
}
