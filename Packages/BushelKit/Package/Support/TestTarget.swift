//
// TestTarget.swift
// Copyright (c) 2024 BrightDigit.
//

protocol TestTarget: Target {}

extension TestTarget {
  var targetType: TargetType {
    .test
  }
}
