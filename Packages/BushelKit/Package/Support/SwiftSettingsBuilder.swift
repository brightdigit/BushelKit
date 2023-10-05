//
// SwiftSettingsBuilder.swift
// Copyright (c) 2023 BrightDigit.
//

@resultBuilder
enum SwiftSettingsBuilder {
  static func buildPartialBlock(first: SwiftSetting) -> [SwiftSetting] {
    [first]
  }

  static func buildPartialBlock(accumulated: [SwiftSetting], next: SwiftSetting) -> [SwiftSetting] {
    accumulated + [next]
  }
}
