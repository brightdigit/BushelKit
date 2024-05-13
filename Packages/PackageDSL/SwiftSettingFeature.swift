//
// SwiftSettingFeature.swift
// Copyright (c) 2024 BrightDigit.
// Licensed under MIT License
//

import PackageDescription

public protocol SwiftSettingFeature: _Named, SwiftSettingConvertible {
    var featureState: FeatureState { get }
}

public extension SwiftSettingFeature {
    var featureState: FeatureState {
        .upcoming
    }

    var setting: SwiftSetting {
        featureState.swiftSetting(name: name)
    }
}
