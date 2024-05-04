//
// BushelFactory.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelFactory: TargetDependency {
  var package: PackageDependency {
    BushelKit()
  }
}
