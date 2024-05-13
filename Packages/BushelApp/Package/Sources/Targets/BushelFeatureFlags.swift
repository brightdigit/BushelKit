//
// BushelFeatureFlags.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelFeatureFlags: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    FeatherQuill()
  }
}
