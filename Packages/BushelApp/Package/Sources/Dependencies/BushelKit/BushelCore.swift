//
// BushelCore.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelCore: TargetDependency {
  var package: PackageDependency {
    BushelKit()
  }
}
