//
// RadiantProgress.swift
// Copyright (c) 2024 BrightDigit.
//

struct RadiantProgress: TargetDependency {
  var package: PackageDependency {
    RadiantKit()
  }
}
