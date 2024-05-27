//
// SentryCocoa.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct SentryCocoa: PackageDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.26.0")
  }
}
