//
// BushelLibrary.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelLibrary: TargetDependency {
  var package: PackageDependency {
    BushelKit()
  }
}
