//
// BushelLogging.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelLogging: TargetDependency {
  var package: PackageDependency {
    BushelKit()
  }
}
