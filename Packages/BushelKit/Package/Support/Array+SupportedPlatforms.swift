//
// Array+SupportedPlatforms.swift
// Copyright (c) 2024 BrightDigit.
//

extension Array: SupportedPlatforms where Element == SupportedPlatform {
  func appending(_ platforms: any SupportedPlatforms) -> Self {
    self + .init(platforms)
  }
}
