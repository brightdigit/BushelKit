//
// Array+TestTargets.swift
// Copyright (c) 2024 BrightDigit.
//

extension Array: TestTargets where Element == TestTarget {
  func appending(_ testTargets: any TestTargets) -> [TestTarget] {
    self + testTargets
  }
}
