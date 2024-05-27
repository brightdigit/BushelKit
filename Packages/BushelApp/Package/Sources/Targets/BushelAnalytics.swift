//
// BushelAnalytics.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelAnalytics: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    AviaryInsights()
  }
}
