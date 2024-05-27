//
// Sentry.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct Sentry: TargetDependency {
  var package: PackageDependency {
    SentryCocoa()
  }
}
