//
// AviaryInsights.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct AviaryInsights: PackageDependency, TargetDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/brightdigit/AviaryInsights.git", from: "1.0.0-beta.1")
  }
}
