//
// InferSendableFromCaptures.swift
// Copyright (c) 2024 BrightDigit.
// Licensed under MIT License
//

// from proposal https://github.com/apple/swift-evolution/blob/main/proposals/0418-inferring-sendable-for-methods.md
public struct InferSendableFromCaptures: SwiftSettingFeature {
    public var featureState: FeatureState {
        return .upcoming
    }
}