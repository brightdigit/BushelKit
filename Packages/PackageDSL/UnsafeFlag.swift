//
// UnsafeFlag.swift
// Copyright (c) 2024 BrightDigit.
// Licensed under MIT License
//

import PackageDescription

public protocol UnsafeFlag: SwiftSettingConvertible, _Named {
    var unsafeFlagArgument: String { get }
}

public extension UnsafeFlag {
    var unsafeFlagArgument: String {
        name.camelToSnakeCase()
    }

    var setting: SwiftSetting {
        .unsafeFlags([unsafeFlagArgument])
    }
}
