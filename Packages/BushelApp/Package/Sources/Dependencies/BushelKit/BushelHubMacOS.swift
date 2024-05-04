//
// BushelHubMacOS.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelHubMacOS: TargetDependency {
  var package: PackageDependency {
    BushelKit()
  }
}
