//
// TestTarget.swift
// Copyright (c) 2024 BrightDigit.
// Licensed under MIT License
//

public protocol TestTarget: Target, GroupBuildable {}

public extension TestTarget {
    var targetType: TargetType {
        .test
    }
}
