//
// TestTargetBuilder.swift
// Copyright (c) 2024 BrightDigit.
//

@resultBuilder
enum TestTargetBuilder {
  static func buildPartialBlock(first: TestTarget) -> any TestTargets {
    [first]
  }

  static func buildPartialBlock(accumulated: any TestTargets, next: TestTarget) -> any TestTargets {
    accumulated + [next]
  }
}
