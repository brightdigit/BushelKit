//
// BushelAnalyticsEvents.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelAnalyticsEvents: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelAnalyticsCore()
  }
}
