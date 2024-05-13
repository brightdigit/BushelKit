//
// FeatureState.swift
// Copyright (c) 2024 BrightDigit.
// Licensed under MIT License
//

import PackageDescription

public enum FeatureState {
    case upcoming
    case experimental
}

public extension FeatureState {
    func swiftSetting(name: String) -> SwiftSetting {
        switch self {
        case .experimental:
            .enableExperimentalFeature(name)

        case .upcoming:
            .enableUpcomingFeature(name)
        }
    }
}
