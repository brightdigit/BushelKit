//
// BushelMachine.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelMachine: TargetDependency {
  var package: PackageDependency {
    BushelKit()
  }
}
