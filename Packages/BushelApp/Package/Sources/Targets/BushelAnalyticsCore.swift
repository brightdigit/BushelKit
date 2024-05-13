//
// BushelAnalyticsCore.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelAnalyticsCore: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    AviaryInsights()
  }
}
