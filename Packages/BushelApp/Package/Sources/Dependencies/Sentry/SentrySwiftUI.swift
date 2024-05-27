//
// SentrySwiftUI.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct SentrySwiftUI: TargetDependency {
  var package: PackageDependency {
    SentryCocoa()
  }
}
