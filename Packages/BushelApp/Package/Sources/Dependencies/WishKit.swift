//
// WishKit.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation
import PackageDescription

struct WishKit: PackageDependency, TargetDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/wishkit/wishkit-ios.git", from: "4.1.0")
  }

  var condition: TargetDependencyCondition? {
    .onlyApple
  }
}

extension TargetDependencyCondition {
  static let onlyApple: TargetDependencyCondition? = .when(platforms: [
    .iOS,
    .macOS,
    .tvOS,
    .watchOS,
    .macCatalyst
  ])
}
