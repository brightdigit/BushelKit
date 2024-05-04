//
// BushelHub.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelHub: TargetDependency {
  var package: PackageDependency {
    BushelKit()
  }
}
