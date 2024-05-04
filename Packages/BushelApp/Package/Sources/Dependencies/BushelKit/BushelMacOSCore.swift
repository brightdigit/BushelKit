//
// BushelMacOSCore.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMacOSCore: TargetDependency {
  var package: PackageDependency {
    BushelKit()
  }
}
