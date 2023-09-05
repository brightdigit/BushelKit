//
// Product+Target.swift
// Copyright (c) 2023 BrightDigit.
//

extension Product where Self: Target {
  var productTargets: [Target] {
    [self]
  }

  var targetType: TargetType {
    switch self.productType {
    case .library:
      .regular

    case .executable:
      .executable
    }
  }
}
